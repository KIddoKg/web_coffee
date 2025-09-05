part of '../home_screen.dart';

class _FooterWidget extends StatefulWidget {
  const _FooterWidget({super.key});

  @override
  State<_FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<_FooterWidget> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;

    return Consumer<HomeScreenVm>(builder: (context, vm, child) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity, // full width parent
                height: 500, // chiều cao mong muốn
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    Assets.png.hh.keyName,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 64,
            ),
            Padding(
              padding: AppStyle.padding_LR_64(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KSText(
                          textAlign: TextAlign.left,
                          S.current.name_coffee,
                          style: KSTheme.of(context)
                              .style
                              .ts28w700
                              .copyWith(color: AppStyle.whiteBg),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        HoverText(
                          text: S.current.address,
                          onTap: () {
                            vm.openMap(10.7259948, 106.6153045);
                          },
                          style: KSTheme.of(context).style.ts14w400.copyWith(
                              color: AppStyle.whiteBg,
                              fontFamily: FontFamily.roboto),
                          normalColor: AppStyle.whiteBg,
                          hoverColor:
                              AppStyle.primaryGreen_0_81_49, // màu khi hover
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        HoverText(
                          text: "090 338 32 36",
                          onTap: () {
                            vm.callPhoneNumber("0903383236");
                          },
                          style: KSTheme.of(context).style.ts14w400.copyWith(
                              color: AppStyle.whiteBg,
                              fontFamily: FontFamily.roboto),
                          normalColor: AppStyle.whiteBg,
                          hoverColor:
                              AppStyle.primaryGreen_0_81_49, // màu khi hover
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KSText(
                          textAlign: TextAlign.left,
                          S.current.about_store,
                          style: KSTheme.of(context)
                              .style
                              .ts28w700
                              .copyWith(color: AppStyle.whiteBg),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        HoverText(
                          text: S.current.home,
                          onTap: () {
                            vm.scrollToTarget(vm.home);
                          },
                          style: KSTheme.of(context).style.ts14w500.copyWith(
                              color: AppStyle.whiteBg,
                              fontFamily: FontFamily.roboto),
                          normalColor: AppStyle.whiteBg,
                          hoverColor:
                              AppStyle.primaryGreen_0_81_49, // màu khi hover
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        HoverText(
                          text: S.current.about,
                          onTap: () {
                            vm.scrollToTarget(vm.about);
                          },
                          style: KSTheme.of(context).style.ts14w500.copyWith(
                              color: AppStyle.whiteBg,
                              fontFamily: FontFamily.roboto),
                          normalColor: AppStyle.whiteBg,
                          hoverColor:
                              AppStyle.primaryGreen_0_81_49, // màu khi hover
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        HoverText(
                          text: S.current.products,
                          onTap: () {
                            vm.scrollToTarget(vm.product);
                          },
                          style: KSTheme.of(context).style.ts14w500.copyWith(
                              color: AppStyle.whiteBg,
                              fontFamily: FontFamily.roboto),
                          normalColor: AppStyle.whiteBg,
                          hoverColor:
                              AppStyle.primaryGreen_0_81_49, // màu khi hover
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        HoverText(
                          text: S.current.advertisement,
                          onTap: () {
                            vm.scrollToTarget(vm.ads);
                          },
                          style: KSTheme.of(context).style.ts14w500.copyWith(
                              color: AppStyle.whiteBg,
                              fontFamily: FontFamily.roboto),
                          normalColor: AppStyle.whiteBg,
                          hoverColor:
                              AppStyle.primaryGreen_0_81_49, // màu khi hover
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        HoverText(
                          text: S.current.feedback,
                          onTap: () {
                            vm.scrollToTarget(vm.feedback);
                          },
                          style: KSTheme.of(context).style.ts14w500.copyWith(
                              color: AppStyle.whiteBg,
                              fontFamily: FontFamily.roboto),
                          normalColor: AppStyle.whiteBg,
                          hoverColor:
                              AppStyle.primaryGreen_0_81_49, // màu khi hover
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 64,
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KSText(
                          textAlign: TextAlign.left,
                          S.current.languages,
                          style: KSTheme.of(context)
                              .style
                              .ts28w700
                              .copyWith(color: AppStyle.whiteBg),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: vm.languages.map((lang) {
                            final isSelected = lang == vm.selectedLang;
                            return ChoiceChip(
                              surfaceTintColor: Colors.transparent,
                              label: KSText(
                                lang == 'vi'
                                    ? S.current.vietnamese
                                    : S.current.english,
                              ),
                              selected: isSelected,
                              onSelected: (_) => vm.setLang(context, lang),
                              labelStyle:
                                  KSTheme.of(context).style.ts15w500.copyWith(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.white,
                                        fontFamily: FontFamily.roboto,
                                      ),
                              selectedColor: AppStyle.primaryGreen_0_81_49,
                              backgroundColor: Colors.black,
                              showCheckmark: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                  color: Colors.black, // 👈 ép trong suốt
                                  width: 0,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 128,
            ),
            Padding(
              padding: AppStyle.padding_LR_64(),
              child: Row(
                children: [
                  KSText(
                    "© 2025 XANH COFFEE INC. All rights reserved.",
                    style: KSTheme.of(context).style.ts14w500.copyWith(
                        color: AppStyle.primaryGrayWord,
                        fontFamily: FontFamily.roboto),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          // khoảng cách giữa icon và vòng ngoài
                          decoration: BoxDecoration(
                            color: Colors.transparent, // màu nền của vòng ngoài
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // màu viền
                              width: 1, // độ dày viền
                            ),
                          ),
                          child: SvgPicture.asset(
                            Assets.svg.svgFacebook.keyName,
                            color: Colors.white, // hoặc AppStyle.whiteBg
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          // khoảng cách giữa icon và vòng ngoài
                          decoration: BoxDecoration(
                            color: Colors.transparent, // màu nền của vòng ngoài
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // màu viền
                              width: 1, // độ dày viền
                            ),
                          ),
                          child: SvgPicture.asset(
                            Assets.svg.svgZalo.keyName,
                            color: Colors.white, // hoặc AppStyle.whiteBg
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          // khoảng cách giữa icon và vòng ngoài
                          decoration: BoxDecoration(
                            color: Colors.transparent, // màu nền của vòng ngoài
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // màu viền
                              width: 1, // độ dày viền
                            ),
                          ),
                          child: SvgPicture.asset(
                            Assets.svg.svgInstagram.keyName,
                            color: Colors.white, // hoặc AppStyle.whiteBg
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      );
    });
  }
}
