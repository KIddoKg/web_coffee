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
        color: AppStyle.whiteYellow,
        child: Padding(
          padding: AppStyle.padding_LR_16().copyWith(
              left: width < 1200 ? 0 : width * 0.15,
              right: width < 1200 ? 0 : width * 0.15),
          child: Padding(
              padding: AppStyle.padding_LR_64(),
              child: Column(
                children: vm.blogs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final ad = entry.value;
                  return AdCard(
                    vm:vm,
                    ad: ad,
                    imageLeft: index % 2 == 0,
                    // Lần đầu image bên trái, lần sau bên phải
                    onButtonTap: () => vm.scrollToTarget(vm.product),
                  );
                }).toList(),
              )),
        ),
      );
    });
  }
}


class AdCard extends StatelessWidget {
  final BlogModel ad;
  final bool imageLeft;
  final VoidCallback onButtonTap;
  final HomeScreenVm vm;

  const AdCard({
    Key? key,
    required this.ad,
    this.imageLeft = true,
    required this.onButtonTap,
    required this.vm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageWidget = Expanded(
      flex: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          ad.linkImg ?? "",
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child; // ✅ Ảnh đã load xong
            }
            return const SizedBox(
              // width: 40,
              // height: 40,
              child: Center(child: LoadingLottie()),
            );
          },
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.broken_image,
            size: 40,
            color: Colors.grey,
          ),
        ),
      ),
    );

    final textWidget = Flexible(
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
                ad.title.toUpperCase(),
                style: KSTheme.of(context).style.ts14w400.copyWith(
                    color: AppStyle.blackLite, fontFamily: FontFamily.roboto),
              ),
              SizedBox(height: 32),
              KSText(
                textAlign: TextAlign.left,
                ad.mainDetail,
                style: KSTheme.of(context).style.ts42w500,
              ),
              SizedBox(height: 16),
              KSText(
                textAlign: TextAlign.left,
                ad.subDetail ?? "",
                style: KSTheme.of(context).style.ts14w400.copyWith(
                    color: AppStyle.primaryGrayWord,
                    fontFamily: FontFamily.roboto),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: 120,
                child: KSButton(
                  onTap: onButtonTap,
                  height: 35,
                  radius: 16,
                  fontColor: AppStyle.primaryGreen_0_81_49,
                  border: AppStyle.primaryGreen_0_81_49,
                  backgroundColor: Colors.transparent,
                  S.current.order_now,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final textEngWidget = Flexible(
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
                ad.titleEn?.toUpperCase()??
                ad.title.toUpperCase(),
                style: KSTheme.of(context).style.ts14w400.copyWith(
                    color: AppStyle.blackLite, fontFamily: FontFamily.roboto),
              ),
              SizedBox(height: 32),
              KSText(
                textAlign: TextAlign.left,
                ad.mainDetailEn ??   ad.mainDetail,
                style: KSTheme.of(context).style.ts42w500,
              ),
              SizedBox(height: 16),
              KSText(
                textAlign: TextAlign.left,
                ad.subDetailEn ?? ad.subDetail!,
                style: KSTheme.of(context).style.ts14w400.copyWith(
                    color: AppStyle.primaryGrayWord,
                    fontFamily: FontFamily.roboto),
              ),

              SizedBox(height: 32),
              SizedBox(
                width: 120,
                child: KSButton(
                  onTap: onButtonTap,
                  height: 35,
                  radius: 16,
                  fontColor: AppStyle.primaryGreen_0_81_49,
                  border: AppStyle.primaryGreen_0_81_49,
                  backgroundColor: Colors.transparent,
                  S.current.order_now,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Row(
        children: imageLeft
            ? [imageWidget, Spacer(), vm.selectedLang == "vi" ?  textWidget : textEngWidget]
            : [vm.selectedLang == "vi" ?  textWidget : textEngWidget, Spacer(), imageWidget],
      ),
    );
  }
}
