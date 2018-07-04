cmd_kernel/printk/built-in.o :=  arm-linux-gnueabihf-ld -EL    -r -o kernel/printk/built-in.o kernel/printk/printk.o kernel/printk/printk_safe.o 
