cmd_arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dtb := mkdir -p arch/arm/boot/dts/ ; arm-linux-gnueabihf-gcc -E -Wp,-MD,arch/arm/boot/dts/.sun8i-a83t-cubietruck-plus.dtb.d.pre.tmp -nostdinc -I./arch/arm/boot/dts -I./arch/arm/boot/dts/include -I./drivers/of/testcase-data -undef -D__DTS__ -x assembler-with-cpp -o arch/arm/boot/dts/.sun8i-a83t-cubietruck-plus.dtb.dts.tmp arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts ; ./scripts/dtc/dtc -O dtb -o arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dtb -b 0 -i arch/arm/boot/dts/ -Wno-unit_address_vs_reg -d arch/arm/boot/dts/.sun8i-a83t-cubietruck-plus.dtb.d.dtc.tmp arch/arm/boot/dts/.sun8i-a83t-cubietruck-plus.dtb.dts.tmp ; cat arch/arm/boot/dts/.sun8i-a83t-cubietruck-plus.dtb.d.pre.tmp arch/arm/boot/dts/.sun8i-a83t-cubietruck-plus.dtb.d.dtc.tmp > arch/arm/boot/dts/.sun8i-a83t-cubietruck-plus.dtb.d

source_arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dtb := arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts

deps_arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dtb := \
  arch/arm/boot/dts/sun8i-a83t.dtsi \
  arch/arm/boot/dts/skeleton.dtsi \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/arm-gic.h \
  arch/arm/boot/dts/include/dt-bindings/interrupt-controller/irq.h \
  arch/arm/boot/dts/include/dt-bindings/pinctrl/sun4i-a10.h \

arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dtb: $(deps_arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dtb)

$(deps_arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dtb):
