cmd_kernel/cgroup/built-in.o :=  arm-linux-gnueabihf-ld -EL    -r -o kernel/cgroup/built-in.o kernel/cgroup/cgroup.o kernel/cgroup/namespace.o kernel/cgroup/cgroup-v1.o 
