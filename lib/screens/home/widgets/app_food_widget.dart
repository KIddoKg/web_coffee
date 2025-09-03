part of '../home_screen.dart';

class _AppFoodWidget extends StatelessWidget {
  const _AppFoodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;

    return Consumer<HomeScreenVm>(builder: (context, vm, child) {
      return Container(
        // height: 1000,
        // key: vm.ads,
        color: AppStyle.primaryGreen_0_81_49.withOpacity(0.1),
        child: Padding(
          padding: AppStyle.padding_LR_16().copyWith(left: width < 1200 ? 0 : width*0.15, right:  width < 1200 ? 0 : width*0.15),
          child: Padding(
            padding: AppStyle.padding_LR_32(),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 128,),
                KSText(
                  textAlign: TextAlign.left,
                  S.current.title_app_food,
                  style: KSTheme.of(context)
                      .style
                      .ts22w700
                      .copyWith(color: AppStyle.blackLite),
                ),
                SizedBox(
                  height: 16,
                ),
                KSText(
                  textAlign: TextAlign.left,
                  S.current.detail_app_food,
                  style: KSTheme.of(context).style.ts14w400.copyWith(
                      color: AppStyle.blackLite,
                      fontFamily: FontFamily.roboto),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 64,
                          ),
                          Padding(
                            padding: AppStyle.padding_LR_64(),
                            child: Column(
                              children: [
                                Container(
                                    color: AppStyle.primaryColorYellow_244_195_66,
                                    child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Image.asset(Assets.png.pngBe.keyName,width: 200,),
                                    )),
                                SizedBox(
                                  height: 16,
                                ),

                                SizedBox(
                                  width: 120,
                                  child: KSButton(onTap: () {
                                    vm.openLink("https://begroup.onelink.me/ZOqn/ujb96xd3");
                                  },
                                      height: 35,
                                      radius: 16,
                                      fontColor: AppStyle.whiteBg,
                                      border: AppStyle.primaryColorYellow_244_195_66,
                                      backgroundColor: AppStyle.primaryColorYellow_244_195_66,
                                      S.current.order_now),
                                )
                              ],
                            ),
                          ),
                      
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 64,
                          ),
                          Padding(
                            padding: AppStyle.padding_LR_64(),
                            child: Column(
                              children: [
                                ImageFiltered(
                                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                      color: AppStyle.primaryColorRed_219_89_59,
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Image.asset(Assets.png.pngShoppe.keyName,width: 200,),
                                      )),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: KSButton(onTap: () {

                                    vm.openLink("https://shopeefood.vn/");
                                  },
                                      height: 35,
                                      lock: true,
                                      radius: 16,
                                      fontColor: AppStyle.whiteBg,
                                      border: AppStyle.primaryColorRed_219_89_59,
                                      backgroundColor: AppStyle.primaryColorRed_219_89_59,
                                      S.current.order_now),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(height: 128,),
              ],
            ),
          ),
        ),
      );
    });
  }
}
