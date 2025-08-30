part of '../home_mobile_screen.dart';

class _AboutWidget extends StatelessWidget {
  const _AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;

    return Consumer<HomeMobileScreenVm>(builder: (context, vm, child) {
      return   Transform.translate(
        offset: Offset(0, -130),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: ClipPath(
            clipper: TopHalfOvalClipper(curveDepth: 0.23),
            child: Stack(
              children: [
                Container(
                  key: vm.about,
                  height: 450 ,
                  width: 100.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppStyle.whiteYellow,
                        AppStyle.whiteYellow,
                      ],
                    ),
                  ),



                ),
                Center(
                  child: Column(

                    children: [
                      SizedBox(height: 32),
                      IconButton.outlined(
                        onPressed: () {
                          vm.scrollToTarget(vm.about);    FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(
                          Icons.arrow_downward_sharp,
                          size: 35,
                        ),
                        style: IconButton.styleFrom(
                          foregroundColor: AppStyle.primaryGreen_0_81_49,
                          side: BorderSide(
                            color: AppStyle.primaryGreen_0_81_49,
                            width: 1,
                          ),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),

                      SizedBox(height: 64),
                      KSText(
                        S.current.about_us.toUpperCase() ,
                        style: KSTheme.of(context).style.ts14w500.copyWith(color: AppStyle.blackLite, fontFamily: FontFamily.roboto),
                      ),
                      SizedBox(height: 64),
                      SizedBox(
                        width: 0.8*width,
                        child: Column(
                          children: [
                            KSText(
                              // textAlign: TextAlign.center,
                              softWrap: true,
                              S.current.about_detail_one ,
                              style: KSTheme.of(context).style.ts24w500.copyWith(color: AppStyle.blackLite, height: 1.4,),
                              // textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 64,),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 400), // giới hạn chiều rộng
                                child:  KSText(
                                  textAlign: TextAlign.right,
                                  S.current.about_detail_two,
                                  style: KSTheme.of(context).style.ts14w500.copyWith(color: AppStyle.primaryGreen_0_81_49,fontFamily: FontFamily.roboto),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),




                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    });
  }

}
