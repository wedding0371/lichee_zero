cmd_arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dtb := mkdir -p arch/arm/boot/dts/ ; arm-linux-gnueabihf-gcc -E -Wp,-MD,arch/arm/boot/dts/.sun8i-h2-plus-orangepi-zero.dtb.d.pre.tmp -nostdinc -I./arch/arm/boot/dts -I./arch/arm/boot/dts/include -I./drivers/of/testcase-data -undef -D__DTS__ -x assembler-with-cpp -o arch/arm/boot/dts/.sun8i-h2-plus-orangepi-zero.dtb.dts.tmp arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts ; ./scripts/dtc/dtc -O dtb -o arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dtb -b 0 -i arch/arm/boot/dts/ -Wno-unit_address_vs_reg -Wno-simple_bus_reg -Wno-unit_address_format -Wno-pci_bridge -Wno-pci_device_bus_num -Wno-pci_device_reg  -d arch/arm/boot/dts/.sun8i-h2-plus-orangepi-zero.dtb.d.dtc.tmp arch/arm/boot/dts/.sun8i-h2-plus-orangepi-zero.dtb.dts.tmp ; cat arch/arm/boot/dts/.sun8i-h2-plus-orangepi-zero.dtb.d.pre.tmp arch/arm/boot/dts/.sun8i-h2-plus-orangepi-zero.dtb.d.dtc.tmp > arch/arm/boot/dts/.sun8i-h2-plus-orangepi-zero.dtb.d

source_arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dtb := arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts

deps_arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dtb := \
  arch/arm/boot/dts/sun8i-h3.dtsi \
  arch/arm/boot/dts/sunxi-h3-h5.dtsi \
  arch/arm/boot/dts/include/dt-bindings/clock/sun8i-h3-ccu.h \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/arm-gic.h \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/irq.h \
  arch/arm/boot/dts/include/dt-bindings/reset/sun8i-h3-ccu.h \
  arch/arm/boot/dts/sunxi-common-regulators.dtsi \
  arch/arm/boot/dts/include/dt-bindings/gpio/gpio.h \
  arch/arm/boot/dts/include/dt-bindings/input/input.h \
  arch/arm/boot/dts/include/dt-bindings/input/linux-event-codes.h \
  arch/arm/boot/dts/include/dt-bindings/pinctrl/sun4i-a10.h \

arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dtb: $(deps_arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dtb)

$(deps_arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dtb):
