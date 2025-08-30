part of '../home_screen.dart';

class _AdsWidget extends StatelessWidget {
  const _AdsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;

    return Consumer<HomeScreenVm>(builder: (context, vm, child) {
      return Container(
        // height: 1000,
        key: vm.ads,
        color: AppStyle.primaryGreen_0_81_49.withOpacity(0.1),
        child: Padding(
          padding: AppStyle.padding_LR_16().copyWith(left: width < 1200 ? 0 : width*0.15, right:  width < 1200 ? 0 : width*0.15),
          child: Padding(
            padding: AppStyle.padding_LR_64(),
            child: Column(
              children: [
                SizedBox(
                  height: 128,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // nửa width/height
                        child: Image.asset(
                          Assets.png.b5.keyName,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // SizedBox(width: 64,),
                    Spacer(),
                    Flexible(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KSText(
                                textAlign: TextAlign.right,
                                S.current.ads_title_one.toUpperCase(),
                                style: KSTheme.of(context).style.ts14w400.copyWith(
                                    color: AppStyle.blackLite,
                                    fontFamily: FontFamily.roboto),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              KSText(
                                textAlign: TextAlign.left,
                                S.current.ads_first_one,
                                style: KSTheme.of(context).style.ts42w500.copyWith(),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              KSText(
                                textAlign: TextAlign.left,
                                S.current.ads_first_two,
                                style: KSTheme.of(context).style.ts14w400.copyWith(
                                    color: AppStyle.primaryGrayWord,
                                    fontFamily: FontFamily.roboto),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              KSText(
                                textAlign: TextAlign.left,
                                S.current.ads_first_three,
                                style: KSTheme.of(context).style.ts14w400.copyWith(
                                    color: AppStyle.primaryGrayWord,
                                    fontFamily: FontFamily.roboto),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              SizedBox(
                                width: 120,
                                child: KSButton(
                                  onTap: (){
                                    vm.scrollToTarget(vm.product);
                                  },
                                    height: 35,
                                    radius: 16,

                                    fontColor: AppStyle.primaryGreen_0_81_49,
                                    border: AppStyle.primaryGreen_0_81_49,
                                    backgroundColor: Colors.transparent,
                                    S.current.order_now),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),



                  ],
                ),
                SizedBox(
                  height: 128,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KSText(
                                textAlign: TextAlign.right,
                                S.current.ads_title_two.toUpperCase(),
                                style: KSTheme.of(context).style.ts14w400.copyWith(
                                    color: AppStyle.blackLite,
                                    fontFamily: FontFamily.roboto),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              KSText(
                                textAlign: TextAlign.left,
                                S.current.ads_second_one,
                                style: KSTheme.of(context).style.ts42w500.copyWith(),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              KSText(
                                textAlign: TextAlign.left,
                                S.current.ads_second_two,
                                style: KSTheme.of(context).style.ts14w400.copyWith(
                                    color: AppStyle.primaryGrayWord,
                                    fontFamily: FontFamily.roboto),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              KSText(
                                textAlign: TextAlign.left,
                                S.current.ads_second_three,
                                style: KSTheme.of(context).style.ts14w400.copyWith(
                                    color: AppStyle.primaryGrayWord,
                                    fontFamily: FontFamily.roboto),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              SizedBox(
                                width: 120,
                                child: KSButton(
                                    onTap: (){
                                      vm.scrollToTarget(vm.product);
                                    },
                                    height: 35,
                                    radius: 16,

                                    fontColor: AppStyle.primaryGreen_0_81_49,
                                    border: AppStyle.primaryGreen_0_81_49,
                                    backgroundColor: Colors.transparent,
                                    S.current.try_now),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // nửa width/height
                        child: Image.asset(
                          Assets.png.b3.keyName,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // SizedBox(width: 64,),





                  ],
                ),
                SizedBox(
                  height: 128,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
