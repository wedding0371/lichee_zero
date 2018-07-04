cmd_arch/arm/boot/dts/sun8i-a33-olinuxino.dtb := mkdir -p arch/arm/boot/dts/ ; arm-linux-gnueabihf-gcc -E -Wp,-MD,arch/arm/boot/dts/.sun8i-a33-olinuxino.dtb.d.pre.tmp -nostdinc -I./arch/arm/boot/dts -I./arch/arm/boot/dts/include -I./drivers/of/testcase-data -undef -D__DTS__ -x assembler-with-cpp -o arch/arm/boot/dts/.sun8i-a33-olinuxino.dtb.dts.tmp arch/arm/boot/dts/sun8i-a33-olinuxino.dts ; ./scripts/dtc/dtc -O dtb -o arch/arm/boot/dts/sun8i-a33-olinuxino.dtb -b 0 -i arch/arm/boot/dts/ -Wno-unit_address_vs_reg -d arch/arm/boot/dts/.sun8i-a33-olinuxino.dtb.d.dtc.tmp arch/arm/boot/dts/.sun8i-a33-olinuxino.dtb.dts.tmp ; cat arch/arm/boot/dts/.sun8i-a33-olinuxino.dtb.d.pre.tmp arch/arm/boot/dts/.sun8i-a33-olinuxino.dtb.d.dtc.tmp > arch/arm/boot/dts/.sun8i-a33-olinuxino.dtb.d

source_arch/arm/boot/dts/sun8i-a33-olinuxino.dtb := arch/arm/boot/dts/sun8i-a33-olinuxino.dts

deps_arch/arm/boot/dts/sun8i-a33-olinuxino.dtb := \
  arch/arm/boot/dts/sun8i-a33.dtsi \
  arch/arm/boot/dts/sun8i-a23-a33.dtsi \
  arch/arm/boot/dts/skeleton.dtsi \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/arm-gic.h \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/irq.h \
  arch/arm/boot/dts/include/dt-bindings/clock/sun8i-a23-a33-ccu.h \
  arch/arm/boot/dts/include/dt-bindings/pinctrl/sun4i-a10.h \
  arch/arm/boot/dts/include/dt-bindings/reset/sun8i-a23-a33-ccu.h \
  arch/arm/boot/dts/sunxi-common-regulators.dtsi \
  arch/arm/boot/dts/include/dt-bindings/gpio/gpio.h \
  arch/arm/boot/dts/include/dt-bindings/input/input.h \
  arch/arm/boot/dts/include/dt-bindings/input/linux-event-codes.h \
  arch/arm/boot/dts/axp22x.dtsi \

arch/arm/boot/dts/sun8i-a33-olinuxino.dtb: $(deps_arch/arm/boot/dts/sun8i-a33-olinuxino.dtb)

$(deps_arch/arm/boot/dts/sun8i-a33-olinuxino.dtb):
