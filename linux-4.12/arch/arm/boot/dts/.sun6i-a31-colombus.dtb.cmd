cmd_arch/arm/boot/dts/sun6i-a31-colombus.dtb := mkdir -p arch/arm/boot/dts/ ; arm-linux-gnueabihf-gcc -E -Wp,-MD,arch/arm/boot/dts/.sun6i-a31-colombus.dtb.d.pre.tmp -nostdinc -I./arch/arm/boot/dts -I./arch/arm/boot/dts/include -I./drivers/of/testcase-data -undef -D__DTS__ -x assembler-with-cpp -o arch/arm/boot/dts/.sun6i-a31-colombus.dtb.dts.tmp arch/arm/boot/dts/sun6i-a31-colombus.dts ; ./scripts/dtc/dtc -O dtb -o arch/arm/boot/dts/sun6i-a31-colombus.dtb -b 0 -i arch/arm/boot/dts/ -Wno-unit_address_vs_reg -Wno-simple_bus_reg -Wno-unit_address_format -Wno-pci_bridge -Wno-pci_device_bus_num -Wno-pci_device_reg  -d arch/arm/boot/dts/.sun6i-a31-colombus.dtb.d.dtc.tmp arch/arm/boot/dts/.sun6i-a31-colombus.dtb.dts.tmp ; cat arch/arm/boot/dts/.sun6i-a31-colombus.dtb.d.pre.tmp arch/arm/boot/dts/.sun6i-a31-colombus.dtb.d.dtc.tmp > arch/arm/boot/dts/.sun6i-a31-colombus.dtb.d

source_arch/arm/boot/dts/sun6i-a31-colombus.dtb := arch/arm/boot/dts/sun6i-a31-colombus.dts

deps_arch/arm/boot/dts/sun6i-a31-colombus.dtb := \
  arch/arm/boot/dts/sun6i-a31.dtsi \
  arch/arm/boot/dts/skeleton.dtsi \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/arm-gic.h \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/irq.h \
  arch/arm/boot/dts/include/dt-bindings/thermal/thermal.h \
  arch/arm/boot/dts/include/dt-bindings/clock/sun6i-a31-ccu.h \
  arch/arm/boot/dts/include/dt-bindings/reset/sun6i-a31-ccu.h \
  arch/arm/boot/dts/sunxi-common-regulators.dtsi \
  arch/arm/boot/dts/include/dt-bindings/gpio/gpio.h \

arch/arm/boot/dts/sun6i-a31-colombus.dtb: $(deps_arch/arm/boot/dts/sun6i-a31-colombus.dtb)

$(deps_arch/arm/boot/dts/sun6i-a31-colombus.dtb):
