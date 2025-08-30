part of '../home_mobile_screen.dart';

class _HeaderWidget extends StatefulWidget {
  const _HeaderWidget({super.key});

  @override
  State<_HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<_HeaderWidget>
    with TickerProviderStateMixin {
  final List<Widget> cartItems = List.generate(10, (index) {
    return ListTile(
      title: Text("Sản phẩm ${index + 1}"),
      trailing: Text(
        "₫${(index + 1) * 123000}",
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;

    return Consumer<HomeMobileScreenVm>(builder: (context, vm, child) {

      double totalPrice = vm.cartShop.fold(
        0.0, // phải là 0.0 chứ không phải 0
            (sum, item) => sum + item.price * item.amount,
      );

      return Container(
        key: vm.home,
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 720,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              // chỉnh số để bo nhiều/ít
                              child: Image.asset(
                                Assets.png.bc.keyName,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 30,
                  right: 50,
                  child: Row(
                    children: [


                      IconButton(
                        onPressed: () {    FocusScope.of(context).unfocus();},
                        icon: SvgPicture.asset(
                          Assets.svg.svgFind.keyName,
                          color: AppStyle.primaryGreen_0_81_49,
                        ),
                      ),
                      CartClickMenuWidget(

                        icon: Badge(
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          label: Text('${vm.cartShop.length}'),
                          isLabelVisible: vm.cartShop.isNotEmpty,
                          child: AddToCartIcon(
                            key: vm.cartKey,
                            icon:  SvgPicture.asset(
                              Assets.svg.svgCart.keyName,
                              color: AppStyle.primaryGreen_0_81_49,
                            ),

                            // badgeOptions: ,
                            badgeOptions: const BadgeOptions(
                              active: false,
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),

                        items: [
                          ChangeNotifierProvider.value(
                            value:  vm,
                            child: Consumer<HomeMobileScreenVm>(
                              builder: (context, vm, child) => SizedBox(
                                width:  100.w < 400 ?  80.w:400, // bạn muốn menu rộng 400
                                height:  100.h< 500 ?  50.w :500,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    SizedBox(height: 8),
                                    KSText(
                                      "${S.current.total_product}: ${vm.cartShop.fold(0.0, (sum, item) => sum + item.amount)}",
                                      overflow: TextOverflow.ellipsis,
                                      style: KSTheme.of(context).style.ts14w500.copyWith(fontFamily: FontFamily.roboto),
                                    ),
                                    Expanded(
                                      child:vm.cartShop.isNotEmpty ?AnimatedList(
                                        key: vm.listKey,
                                        initialItemCount: vm.cartShop.length,
                                        itemBuilder: (context, index, animation) {
                                          return  SizeTransition(
                                            sizeFactor: animation,
                                            child: CartItemWidget(
                                              product: vm.cartShop[index],
                                              onRemove: () => vm.removeItem(index),
                                              totalMoney: double.parse((vm.cartShop[index].amount * vm.cartShop[index].price).toString()),
                                            ),
                                          );
                                        },
                                      ): LoadingLottie(),
                                    ),
                                      Divider(height: 1,color: AppStyle.primaryGreen_0_81_49,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${S.current.total_pay}: ${vm.totalPrice.toCurrency()}",
                                                style: KSTheme.of(context).style.ts14w500.copyWith(fontFamily: FontFamily.roboto, color: AppStyle.primaryGreen_0_81_49),
                                              ),
                                              SizedBox(height: 8,),
                                              // Spacer(),

                                              MessengerButton(
                                                username: "0869307217",
                                                message: (){
                                                  final productLines = vm.cartShop.map((p) =>
                                                  "${p.name} - ${p.price}₫ x${p.amount}"
                                                  ).join('\n');

                                                  // Tính tổng tiền
                                                  final total = vm.cartShop.fold<int>(0, (sum, p) => sum + p.price * p.amount);
                                                  final message = "$productLines\nTổng tiền: $total₫";
                                                  return (message);

                                                },
                                              ),



                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // AddToCartIcon(
                      //   key: vm.cartKey,
                      //   icon:   IconButton(
                      //     onPressed: () {},
                      //     icon: SvgPicture.asset(
                      //       Assets.svg.svgCart.keyName,
                      //       color: AppStyle.primaryGreen_0_81_49,
                      //     ),
                      //   ),
                      //   badgeOptions: const BadgeOptions(
                      //     active: true,
                      //     backgroundColor: Colors.red,
                      //   ),
                      // ),
                      // IconButton(
                      //   onPressed: () {    FocusScope.of(context).unfocus();},
                      //   icon: SvgPicture.asset(
                      //     Assets.svg.svgPerson.keyName,
                      //     color: AppStyle.primaryGreen_0_81_49,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: const Alignment(0, -0.13), // 0 = giữa, -1 = top
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        KSText(
                          "─ ${S.current.title_coffee.toUpperCase()} ─",
                          style: KSTheme.of(context).style.ts14w600.copyWith(
                              color: AppStyle.primaryGreen_0_81_49,
                              fontFamily: FontFamily.roboto),
                        ),
                        KSText(
                          textAlign: TextAlign.center,
                          S.current.name_coffee,
                          style: KSTheme.of(context)
                              .style
                              .ts80w500
                              .copyWith(color: AppStyle.primaryGreen_0_81_49),
                        ),
                        SizedBox(
                          width: width*0.5,
                          child: KSText(
                            textAlign: TextAlign.center,
                            S.current.detail_name,
                            style: KSTheme.of(context).style.ts14w600.copyWith(
                                color: AppStyle.primaryGreen_0_81_49,
                                fontFamily: FontFamily.roboto),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 50,
                  child: BubbleMenuMobile(
                    items: [
                      S.current.home,
                      S.current.about,
                      S.current.products,
                      S.current.advertisement,
                      S.current.feedback
                    ],
                    keyNav: [
                      vm.home,
                      vm.about,
                      vm.product,
                      vm.ads,
                      vm.feedback
                    ],
                    onItemTap: (value) {
                      vm.scrollToTarget(value);
                    },
                  ),
                ),
              ],
            ),
            _AboutWidget(),
          ],
        ),
      );
    });
  }
}

class CartItemWidget extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;
  final double totalMoney;

  const CartItemWidget({
    super.key,
    required this.product,
    required this.onRemove,
    required this.totalMoney,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      color: AppStyle.primaryGreen_0_81_49.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Hình ảnh
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                      '${S.current.price}: ${double.parse(product.price.toString()).toCurrency()}'),
                  Text('${S.current.amount}: ${product.amount}'),
                ],
              ),
            ),

            // Nút X
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                KSText(
                  textAlign: TextAlign.center,
                  totalMoney.toCurrency(),
                  style: KSTheme.of(context).style.ts14w600.copyWith(
                      color: AppStyle.primaryGreen_0_81_49,
                      fontFamily: FontFamily.roboto),
                ),
                HoverText(
                  text: S.current.delete,
                  onTap: onRemove,
                  style: KSTheme.of(context).style.ts12w400.copyWith(
                      color: AppStyle.whiteBg, fontFamily: FontFamily.roboto),
                  normalColor: AppStyle.primaryGrayWord,
                  hoverColor: AppStyle.primaryRedFF4D4F, // màu khi hover
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TopHalfOvalClipper extends CustomClipper<Path> {
  final double curveDepth; // Tùy chỉnh độ cong

  TopHalfOvalClipper({this.curveDepth = 0.3}); // mặc định 30%

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, size.height * curveDepth);
    path.quadraticBezierTo(
      size.width / 2,
      -size.height * curveDepth, // 🔥 cong hơn
      size.width,
      size.height * curveDepth,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
