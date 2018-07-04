cmd_arch/arm/boot/dts/sun9i-a80-optimus.dtb := mkdir -p arch/arm/boot/dts/ ; arm-linux-gnueabihf-gcc -E -Wp,-MD,arch/arm/boot/dts/.sun9i-a80-optimus.dtb.d.pre.tmp -nostdinc -I./arch/arm/boot/dts -I./arch/arm/boot/dts/include -I./drivers/of/testcase-data -undef -D__DTS__ -x assembler-with-cpp -o arch/arm/boot/dts/.sun9i-a80-optimus.dtb.dts.tmp arch/arm/boot/dts/sun9i-a80-optimus.dts ; ./scripts/dtc/dtc -O dtb -o arch/arm/boot/dts/sun9i-a80-optimus.dtb -b 0 -i arch/arm/boot/dts/ -Wno-unit_address_vs_reg -Wno-simple_bus_reg -Wno-unit_address_format -Wno-pci_bridge -Wno-pci_device_bus_num -Wno-pci_device_reg  -d arch/arm/boot/dts/.sun9i-a80-optimus.dtb.d.dtc.tmp arch/arm/boot/dts/.sun9i-a80-optimus.dtb.dts.tmp ; cat arch/arm/boot/dts/.sun9i-a80-optimus.dtb.d.pre.tmp arch/arm/boot/dts/.sun9i-a80-optimus.dtb.d.dtc.tmp > arch/arm/boot/dts/.sun9i-a80-optimus.dtb.d

source_arch/arm/boot/dts/sun9i-a80-optimus.dtb := arch/arm/boot/dts/sun9i-a80-optimus.dts

deps_arch/arm/boot/dts/sun9i-a80-optimus.dtb := \
  arch/arm/boot/dts/sun9i-a80.dtsi \
  arch/arm/boot/dts/skeleton64.dtsi \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/arm-gic.h \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/irq.h \
  arch/arm/boot/dts/include/dt-bindings/clock/sun9i-a80-ccu.h \
  arch/arm/boot/dts/include/dt-bindings/clock/sun9i-a80-de.h \
  arch/arm/boot/dts/include/dt-bindings/clock/sun9i-a80-usb.h \
  arch/arm/boot/dts/include/dt-bindings/reset/sun9i-a80-ccu.h \
  arch/arm/boot/dts/include/dt-bindings/reset/sun9i-a80-de.h \
  arch/arm/boot/dts/include/dt-bindings/reset/sun9i-a80-usb.h \
  arch/arm/boot/dts/include/dt-bindings/gpio/gpio.h \
  arch/arm/boot/dts/axp809.dtsi \

arch/arm/boot/dts/sun9i-a80-optimus.dtb: $(deps_arch/arm/boot/dts/sun9i-a80-optimus.dtb)

$(deps_arch/arm/boot/dts/sun9i-a80-optimus.dtb):
