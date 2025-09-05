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
                      .ts28w700
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
                  children: vm.qrCodes.map((app) {
                    return Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 64),
                          FoodAppCard(
                            data: app,
                            vm: vm,

                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
Color parseColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor"; // mặc định alpha = 100%
  }
  return Color(int.parse(hexColor, radix: 16));
}

class FoodAppCard extends StatelessWidget {
   final QRCodeModel data;
   final HomeScreenVm vm;

  const FoodAppCard({
    Key? key,
    required this.data,
    required this.vm,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      color: parseColor(data.color??"#fffffff"),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Image.network(data.imageUrl ?? "", width: 200),
      ),
    );

    if (data.isActive == false) {
      cardContent = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: cardContent,
      );
    }

    return Padding(
      padding: AppStyle.padding_LR_32(),
      child: Column(
        children: [
          cardContent,
          SizedBox(height: 16),
          SizedBox(
            width: 190,
            child: KSButton(
              onTap: () => vm.openLink(data.linkUrl),
              height: 35,
              radius: 16,
              lock: data.isActive == false,
              fontColor:parseColor(data.color??"#fffffff"),
              border: parseColor(data.color??"#fffffff"),
              backgroundColor: Colors.white,
              S.current.order_now,
            ),
          ),
        ],
      ),
    );
  }
}
