part of '../home_mobile_screen.dart';

class _FeedbackWidget extends StatelessWidget {
  const _FeedbackWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;

    return Consumer<HomeMobileScreenVm>(builder: (context, vm, child) {
      final feedback = vm.currentFeedback;
      return Padding(
        padding: AppStyle.padding_LR_32(),
        child: Column(
          children: [
            SizedBox(
              key: vm.feedback,
              height: 64,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left image section
                  // Flexible(
                  //   flex: 1,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(16),
                  //     child: Image.asset(
                  //       Assets.png.b2.keyName,
                  //       // Bạn cần thêm hình ảnh vào thư mục assets
                  //       // width: 400,
                  //       height: 500,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),


                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 500,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 64),
                          RatingBarIndicator(
                            unratedColor: AppStyle.primaryGrayLight,
                            rating: feedback.rating,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            itemCount: 5,
                            itemSize: 24.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(height: 64),
                          KSText(
                            feedback.title.toUpperCase(),
                            maxLines: 1,
                            style: KSTheme.of(context).style.ts24w700.copyWith(
                                  color: AppStyle.blackLite,
                                ),
                          ),
                          const SizedBox(height: 16),
                          KSText(
                            '“ ${feedback.comment} ”',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: KSTheme.of(context).style.ts22w300.copyWith(
                                color: AppStyle.primaryGrayWord,
                                fontFamily: FontFamily.roboto),
                          ),
                          const SizedBox(height: 64),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left arrow

                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  hoverColor:AppStyle.primaryGreen_0_81_49.withOpacity(0.1),

                                  icon:  Icon(Icons.arrow_back, color: AppStyle.primaryGreen_0_81_49,),
                                  onPressed:vm.lockPre ? null: () =>
                                    vm.previousFeedback(),

                                ),
                              ),


                              // Name and date
                              Column(
                                children: [
                                  Text(
                                    feedback.reviewer.toUpperCase(),
                                    style: KSTheme.of(context).style.ts14w700.copyWith(
                                      color: AppStyle.blackLite,
                                        fontFamily: FontFamily.roboto
                                    ),
                                  ),
                                  Text(
                                    feedback.date,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),

                              // Right arrow
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  hoverColor:AppStyle.primaryGreen_0_81_49.withOpacity(0.1),


                                  icon:   Icon(Icons.arrow_forward, color: AppStyle.primaryGreen_0_81_49,),
                                  onPressed:vm.lockNext ? null: () {
                                    vm.nextFeedback();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 64,
            ),
          ],
        ),
      );
    });
  }
}
