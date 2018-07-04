cmd_arch/arm/boot/dts/sun5i-a10s-mk802.dtb := mkdir -p arch/arm/boot/dts/ ; arm-linux-gnueabihf-gcc -E -Wp,-MD,arch/arm/boot/dts/.sun5i-a10s-mk802.dtb.d.pre.tmp -nostdinc -I./arch/arm/boot/dts -I./arch/arm/boot/dts/include -I./drivers/of/testcase-data -undef -D__DTS__ -x assembler-with-cpp -o arch/arm/boot/dts/.sun5i-a10s-mk802.dtb.dts.tmp arch/arm/boot/dts/sun5i-a10s-mk802.dts ; ./scripts/dtc/dtc -O dtb -o arch/arm/boot/dts/sun5i-a10s-mk802.dtb -b 0 -i arch/arm/boot/dts/ -Wno-unit_address_vs_reg -Wno-simple_bus_reg -Wno-unit_address_format -Wno-pci_bridge -Wno-pci_device_bus_num -Wno-pci_device_reg  -d arch/arm/boot/dts/.sun5i-a10s-mk802.dtb.d.dtc.tmp arch/arm/boot/dts/.sun5i-a10s-mk802.dtb.dts.tmp ; cat arch/arm/boot/dts/.sun5i-a10s-mk802.dtb.d.pre.tmp arch/arm/boot/dts/.sun5i-a10s-mk802.dtb.d.dtc.tmp > arch/arm/boot/dts/.sun5i-a10s-mk802.dtb.d

source_arch/arm/boot/dts/sun5i-a10s-mk802.dtb := arch/arm/boot/dts/sun5i-a10s-mk802.dts

deps_arch/arm/boot/dts/sun5i-a10s-mk802.dtb := \
  arch/arm/boot/dts/sun5i-a10s.dtsi \
  arch/arm/boot/dts/skeleton.dtsi \
  arch/arm/boot/dts/sun5i.dtsi \
  arch/arm/boot/dts/include/dt-bindings/clock/sun5i-ccu.h \
  arch/arm/boot/dts/include/dt-bindings/dma/sun4i-a10.h \
  arch/arm/boot/dts/include/dt-bindings/reset/sun5i-ccu.h \
  arch/arm/boot/dts/sunxi-common-regulators.dtsi \
  arch/arm/boot/dts/include/dt-bindings/gpio/gpio.h \

arch/arm/boot/dts/sun5i-a10s-mk802.dtb: $(deps_arch/arm/boot/dts/sun5i-a10s-mk802.dtb)

$(deps_arch/arm/boot/dts/sun5i-a10s-mk802.dtb):
