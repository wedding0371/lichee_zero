#include <linux/sched.h>
#include <linux/sched/task.h>
#include <linux/sched/task_stack.h>
#include <linux/interrupt.h>
#include <asm/sections.h>
#include <asm/ptrace.h>
#include <asm/bitops.h>
#include <asm/stacktrace.h>
#include <asm/unwind.h>

#define FRAME_HEADER_SIZE (sizeof(long) * 2)

/*
 * This disables KASAN checking when reading a value from another task's stack,
 * since the other task could be running on another CPU and could have poisoned
 * the stack in the meantime.
 */
#define READ_ONCE_TASK_STACK(task, x)			\
({							\
	unsigned long val;				\
	if (task == current)				\
		val = READ_ONCE(x);			\
	else						\
		val = READ_ONCE_NOCHECK(x);		\
	val;						\
})

static void unwind_dump(struct unwind_state *state)
{
	static bool dumped_before = false;
	bool prev_zero, zero = false;
	unsigned long word, *sp;
	struct stack_info stack_info = {0};
	unsigned long visit_mask = 0;

	if (dumped_before)
		return;

	dumped_before = true;

	printk_deferred("unwind stack type:%d next_sp:%p mask:0x%lx graph_idx:%d\n",
			state->stack_info.type, state->stack_info.next_sp,
			state->stack_mask, state->graph_idx);

	for (sp = state->orig_sp; sp; sp = PTR_ALIGN(stack_info.next_sp, sizeof(long))) {
		if (get_stack_info(sp, state->task, &stack_info, &visit_mask))
			break;

		for (; sp < stack_info.end; sp++) {

			word = READ_ONCE_NOCHECK(*sp);

			prev_zero = zero;
			zero = word == 0;

			if (zero) {
				if (!prev_zero)
					printk_deferred("%p: %0*x ...\n",
							sp, BITS_PER_LONG/4, 0);
				continue;
			}

			printk_deferred("%p: %0*lx (%pB)\n",
					sp, BITS_PER_LONG/4, word, (void *)word);
		}
	}
}

unsigned long unwind_get_return_address(struct unwind_state *state)
{
	if (unwind_done(state))
		return 0;

	return __kernel_text_address(state->ip) ? state->ip : 0;
}
EXPORT_SYMBOL_GPL(unwind_get_return_address);

static size_t regs_size(struct pt_regs *regs)
{
	/* x86_32 regs from kernel mode are two words shorter: */
	if (IS_ENABLED(CONFIG_X86_32) && !user_mode(regs))
		return sizeof(*regs) - 2*sizeof(long);

	return sizeof(*regs);
}

static bool in_entry_code(unsigned long ip)
{
	char *addr = (char *)ip;

	if (addr >= __entry_text_start && addr < __entry_text_end)
		return true;

#if defined(CONFIG_FUNCTION_GRAPH_TRACER) || defined(CONFIG_KASAN)
	if (addr >= __irqentry_text_start && addr < __irqentry_text_end)
		return true;
#endif

	return false;
}

static inline unsigned long *last_frame(struct unwind_state *state)
{
	return (unsigned long *)task_pt_regs(state->task) - 2;
}

#ifdef CONFIG_X86_32
#define GCC_REALIGN_WORDS 3
#else
#define GCC_REALIGN_WORDS 1
#endif

static inline unsigned long *last_aligned_frame(struct unwind_state *state)
{
	return last_frame(state) - GCC_REALIGN_WORDS;
}

static bool is_last_task_frame(struct unwind_state *state)
{
	unsigned long *last_bp = last_frame(state);
	unsigned long *aligned_bp = last_aligned_frame(state);

	/*
	 * We have to check for the last task frame at two different locations
	 * because gcc can occasionally decide to realign the stack pointer and
	 * change the offset of the stack frame in the prologue of a function
	 * called by head/entry code.  Examples:
	 *
	 * <start_secondary>:
	 *      push   %edi
	 *      lea    0x8(%esp),%edi
	 *      and    $0xfffffff8,%esp
	 *      pushl  -0x4(%edi)
	 *      push   %ebp
	 *      mov    %esp,%ebp
	 *
	 * <x86_64_start_kernel>:
	 *      lea    0x8(%rsp),%r10
	 *      and    $0xfffffffffffffff0,%rsp
	 *      pushq  -0x8(%r10)
	 *      push   %rbp
	 *      mov    %rsp,%rbp
	 *
	 * Note that after aligning the stack, it pushes a duplicate copy of
	 * the return address before pushing the frame pointer.
	 */
	return (state->bp == last_bp ||
		(state->bp == aligned_bp && *(aligned_bp+1) == *(last_bp+1)));
}

/*
 * This determines if the frame pointer actually contains an encoded pointer to
 * pt_regs on the stack.  See ENCODE_FRAME_POINTER.
 */
static struct pt_regs *decode_frame_pointer(unsigned long *bp)
{
	unsigned long regs = (unsigned long)bp;

	if (!(regs & 0x1))
		return NULL;

	return (struct pt_regs *)(regs & ~0x1);
}

static bool update_stack_state(struct unwind_state *state,
			       unsigned long *next_bp)
{
	struct stack_info *info = &state->stack_info;
	enum stack_type prev_type = info->type;
	struct pt_regs *regs;
	unsigned long *frame, *prev_frame_end, *addr_p, addr;
	size_t len;

	if (state->regs)
		prev_frame_end = (void *)state->regs + regs_size(state->regs);
	else
		prev_frame_end = (void *)state->bp + FRAME_HEADER_SIZE;

	/* Is the next frame pointer an encoded pointer to pt_regs? */
	regs = decode_frame_pointer(next_bp);
	if (regs) {
		frame = (unsigned long *)regs;
		len = regs_size(regs);
		state->got_irq = true;
	} else {
		frame = next_bp;
		len = FRAME_HEADER_SIZE;
	}

	/*
	 * If the next bp isn't on the current stack, switch to the next one.
	 *
	 * We may have to traverse multiple stacks to deal with the possibility
	 * that info->next_sp could point to an empty stack and the next bp
	 * could be on a subsequent stack.
	 */
	while (!on_stack(info, frame, len))
		if (get_stack_info(info->next_sp, state->task, info,
				   &state->stack_mask))
			return false;

	/* Make sure it only unwinds up and doesn't overlap the prev frame: */
	if (state->orig_sp && state->stack_info.type == prev_type &&
	    frame < prev_frame_end)
		return false;

	/* Move state to the next frame: */
	if (regs) {
		state->regs = regs;
		state->bp = NULL;
	} else {
		state->bp = next_bp;
		state->regs = NULL;
	}

	/* Save the return address: */
	if (state->regs && user_mode(state->regs))
		state->ip = 0;
	else {
		addr_p = unwind_get_return_address_ptr(state);
		addr = READ_ONCE_TASK_STACK(state->task, *addr_p);
		state->ip = ftrace_graph_ret_addr(state->task, &state->graph_idx,
						  addr, addr_p);
	}

	/* Save the original stack pointer for unwind_dump(): */
	if (!state->orig_sp)
		state->orig_sp = frame;

	return true;
}

bool unwind_next_frame(struct unwind_state *state)
{
	struct pt_regs *regs;
	unsigned long *next_bp;

	if (unwind_done(state))
		return false;

	/* Have we reached the end? */
	if (state->regs && user_mode(state->regs))
		goto the_end;

	if (is_last_task_frame(state)) {
		regs = task_pt_regs(state->task);

		/*
		 * kthreads (other than the boot CPU's idle thread) have some
		 * partial regs at the end of their stack which were placed
		 * there by copy_thread_tls().  But the regs don't have any
		 * useful information, so we can skip them.
		 *
		 * This user_mode() check is slightly broader than a PF_KTHREAD
		 * check because it also catches the awkward situation where a
		 * newly forked kthread transitions into a user task by calling
		 * do_execve(), which eventually clears PF_KTHREAD.
		 */
		if (!user_mode(regs))
			goto the_end;

		/*
		 * We're almost at the end, but not quite: there's still the
		 * syscall regs frame.  Entry code doesn't encode the regs
		 * pointer for syscalls, so we have to set it manually.
		 */
		state->regs = regs;
		state->bp = NULL;
		state->ip = 0;
		return true;
	}

	/* Get the next frame pointer: */
	if (state->regs)
		next_bp = (unsigned long *)state->regs->bp;
	else
		next_bp = (unsigned long *)READ_ONCE_TASK_STACK(state->task, *state->bp);

	/* Move to the next frame if it's safe: */
	if (!update_stack_state(state, next_bp))
		goto bad_address;

	return true;

bad_address:
	state->error = true;

	/*
	 * When unwinding a non-current task, the task might actually be
	 * running on another CPU, in which case it could be modifying its
	 * stack while we're reading it.  This is generally not a problem and
	 * can be ignored as long as the caller understands that unwinding
	 * another task will not always succeed.
	 */
	if (state->task != current)
		goto the_end;

	/*
	 * Don't warn if the unwinder got lost due to an interrupt in entry
	 * code or in the C handler before the first frame pointer got set up:
	 */
	if (state->got_irq && in_entry_code(state->ip))
		goto the_end;
	if (state->regs &&
	    state->regs->sp >= (unsigned long)last_aligned_frame(state) &&
	    state->regs->sp < (unsigned long)task_pt_regs(state->task))
		goto the_end;

	if (state->regs) {
		printk_deferred_once(KERN_WARNING
			"WARNING: kernel stack regs at %p in %s:%d has bad 'bp' value %p\n",
			state->regs, state->task->comm,
			state->task->pid, next_bp);
		unwind_dump(state);
	} else {
		printk_deferred_once(KERN_WARNING
			"WARNING: kernel stack frame pointer at %p in %s:%d has bad value %p\n",
			state->bp, state->task->comm,
			state->task->pid, next_bp);
		unwind_dump(state);
	}
the_end:
	state->stack_info.type = STACK_TYPE_UNKNOWN;
	return false;
}
EXPORT_SYMBOL_GPL(unwind_next_frame);

void __unwind_start(struct unwind_state *state, struct task_struct *task,
		    struct pt_regs *regs, unsigned long *first_frame)
{
	unsigned long *bp;

	memset(state, 0, sizeof(*state));
	state->task = task;
	state->got_irq = (regs);

	/* Don't even attempt to start from user mode regs: */
	if (regs && user_mode(regs)) {
		state->stack_info.type = STACK_TYPE_UNKNOWN;
		return;
	}

	bp = get_frame_pointer(task, regs);

	/* Initialize stack info and make sure the frame data is accessible: */
	get_stack_info(bp, state->task, &state->stack_info,
		       &state->stack_mask);
	update_stack_state(state, bp);

	/*
	 * The caller can provide the address of the first frame directly
	 * (first_frame) or indirectly (regs->sp) to indicate which stack frame
	 * to start unwinding at.  Skip ahead until we reach it.
	 */
	while (!unwind_done(state) &&
	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
			state->bp < first_frame))
		unwind_next_frame(state);
}
EXPORT_SYMBOL_GPL(__unwind_start);