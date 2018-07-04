cmd_drivers/ata/built-in.o :=  arm-linux-gnueabihf-ld -EL    -r -o drivers/ata/built-in.o drivers/ata/libata.o drivers/ata/ahci_sunxi.o drivers/ata/libahci.o drivers/ata/libahci_platform.o 
