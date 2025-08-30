import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xanh_coffee/screens/home/viewModel/home_screen_vm.dart';
import 'package:xanh_coffee/share/size_configs.dart';
import 'package:sizer/sizer.dart';
import 'package:xanh_coffee/share/text_style.dart';

import '../generated/fonts.gen.dart';
import '../generated/l10n.dart';
import 'app_imports.dart';
import 'package:lottie/lottie.dart';

class KSIconTextButton extends StatelessWidget {
  final String iconAsset;
  final String text;
  final VoidCallback onTap;
  final double radius;
  final TextStyle? textStyle;
  final double? iconHeight;
  final Widget? imgIcon;

  const KSIconTextButton({
    super.key,
    required this.iconAsset,
    required this.text,
    required this.onTap,
    this.radius = 24,
    this.textStyle,
    this.iconHeight,
    this.imgIcon,
  });

  @override
  Widget build(BuildContext context) {
    return KSInkWellUnFocus(
      radius: radius,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            iconAsset,
            height: iconHeight ?? SizeConfig.buttonSize,
          ),
          (imgIcon != null)
              ? imgIcon!
              : KSText(
                  text,
                  style: textStyle ??
                      KSTheme.of(context)
                          .style
                          .ts14w700
                          .copyWith(color: AppStyle.primaryNeutral),
                ),
        ],
      ),
    );
  }
}

class TemperatureContainerWidget extends StatelessWidget {
  final String title;
  final List<String> temperatures;
  final List<String>? temperatureTitles;
  final Widget? imgIcon;
  final Widget? custom;

  const TemperatureContainerWidget({
    super.key,
    required this.title,
    required this.temperatures,
    this.temperatureTitles,
    this.imgIcon,
    this.custom,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyle.padding_all_16(),
      child: Container(
        height: 35.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppStyle.primaryBlue060C29,
              AppStyle.primaryBlue040C30.withOpacity(0.5),
            ],
            stops: [0.0, 1],
          ),
          border: Border.all(width: 2, color: Colors.white),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(16),
        child: custom != null
            ? custom!
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KSText(
                    title,
                    style: KSTheme.of(context)
                        .style
                        .ts15w500
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(temperatures.length, (index) {
                          final temp = temperatures[index];
                          final tempTitle = temperatureTitles != null &&
                                  index < temperatureTitles!.length
                              ? temperatureTitles![index]
                              : "Nhiệt độ hiện tại";

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              width: 13.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppStyle.primaryBlue060C29,
                                    AppStyle.primaryBlue040C30.withOpacity(0.5),
                                  ],
                                  stops: [0.1, 1],
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KSText(
                                    maxLines: 1,
                                    tempTitle,
                                    style: KSTheme.of(context)
                                        .style
                                        .ts12w400
                                        .copyWith(
                                            color: AppStyle.primaryGrayA0AEC0),
                                  ),
                                  KSText(
                                    temp,
                                    style: KSTheme.of(context)
                                        .style
                                        .ts16w500
                                        .copyWith(color: AppStyle.whiteBg),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 16),
                      if (imgIcon != null)
                        Expanded(child: Center(child: imgIcon!)),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class TimeColumn extends StatelessWidget {
  final String topLeft;
  final String topRight;
  final String label;
  final double size;
  final double ver;

  const TimeColumn({
    required this.topLeft,
    required this.topRight,
    required this.label,
    this.size = 70,
    this.ver = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // dòng chứa [1][1]
        Row(
          children: [
            TimeBox(value: topLeft, size: size,ver: ver),
            const SizedBox(width: 4),
            TimeBox(value: topRight, size: size,ver: ver),
          ],
        ),
        const SizedBox(height: 16),
        KSText(
          label,
          style: KSTextStyle()
              .style(
                20,
                FontWeight.w500,
                fontBuilder: GoogleFonts.cormorantInfant,
              )
              .copyWith(color: AppStyle.whiteBg),
        ),
      ],
    );
  }
}

class TimeBox extends StatelessWidget {
  final double size;
  final String value;
  final double ver;

  const TimeBox({required this.value, this.size = 70,this.ver = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ver, vertical: 8),
      decoration: BoxDecoration(
        color: AppStyle.primaryGrayLight2,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: AppStyle.padding_LR_8(),
        child: KSText(
          value,
          style: KSTextStyle()
              .style(
            size,
                FontWeight.w600,
                fontBuilder: GoogleFonts.cormorantInfant,
              )
              .copyWith(color: AppStyle.primaryColorBlack),
        ),
      ),
    );
  }
}

class GroupedFocusCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final int itemsPerPage;
  final Duration autoPlayInterval;
  final double focusScale;
  final double normalScale;
  final double focusHeight;
  final double normalHeight;
  final void Function(int index)? onTap;


  const GroupedFocusCarousel({
    super.key,
    required this.imagePaths,
    this.itemsPerPage = 4,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.focusScale = 0.30,
    this.normalScale = 0.14,
    this.focusHeight = 200,
    this.normalHeight = 750,
    this.onTap,
  });

  @override
  State<GroupedFocusCarousel> createState() => _GroupedFocusCarouselState();
}

class _GroupedFocusCarouselState extends State<GroupedFocusCarousel> {
  int currentGroupIndex = 0;
  int currentFocusIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayInterval, (_) => _next());
  }

  void _next() {
    _resetTimer();
    setState(() {
      currentFocusIndex++;
      if (currentFocusIndex >= widget.itemsPerPage) {
        currentFocusIndex = 0;
        currentGroupIndex++;
        if ((currentGroupIndex * widget.itemsPerPage) >=
            widget.imagePaths.length) {
          currentGroupIndex = 0;
        }
      }
    });
  }

  void _prev() {
    _resetTimer();
    setState(() {
      currentFocusIndex--;
      if (currentFocusIndex < 0) {
        currentGroupIndex--;

        if (currentGroupIndex < 0) {
          currentGroupIndex =
              (widget.imagePaths.length / widget.itemsPerPage).ceil() - 1;
        }

        // 👇 lấy số ảnh của nhóm hiện tại
        final start = currentGroupIndex * widget.itemsPerPage;
        final end = (start + widget.itemsPerPage) <= widget.imagePaths.length
            ? start + widget.itemsPerPage
            : widget.imagePaths.length;
        final groupLength = end - start;

        currentFocusIndex = groupLength - 1;
      }
    });
  }




  void _resetTimer() {
    _timer?.cancel();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final start = currentGroupIndex * widget.itemsPerPage;
    final end = (start + widget.itemsPerPage) <= widget.imagePaths.length
        ? start + widget.itemsPerPage
        : widget.imagePaths.length;
    final currentImages = widget.imagePaths.sublist(start, end);

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final isForward = true; // bạn có thể thay đổi để phân biệt trái/phải
            final offsetTween = Tween<Offset>(
              begin: Offset(isForward ? 1.0 : -1.0, 0),
              end: Offset.zero,
            );

            return SlideTransition(
              position: offsetTween.animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
          child: Container(
            key: ValueKey(currentGroupIndex), // 👈 Rất quan trọng để Switcher biết khi nào animate
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(currentImages.length, (index) {
                final isFocused = index == currentFocusIndex;
                return GestureDetector(
                  onTap: () {
                    final globalIndex =
                        currentGroupIndex * widget.itemsPerPage + index;
                    widget.onTap?.call(globalIndex);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: isFocused
                        ? screenWidth * widget.focusScale
                        : screenWidth * widget.normalScale,
                    height: widget.normalHeight,
                    child: Image.network(
                      currentImages[index],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null ? child : LoadingLottie(),
                      errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, size: 40)),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        Positioned(
          left: 16,
          child: _ArrowButton(
            icon: Icons.arrow_back_ios_new,
            onPressed: _prev,
          ),
        ),
        Positioned(
          right: 16,
          child: _ArrowButton(
            icon: Icons.arrow_forward_ios,
            onPressed: _next,
          ),
        ),
      ],
    );
  }
}






class GroupedFocusCarouselMobile extends StatefulWidget {
  final List<String> imagePaths;
  final Duration autoPlayInterval;
  final double focusScale;
  final double focusHeight;
  final void Function(int index)? onTap;

  const GroupedFocusCarouselMobile({
    super.key,
    required this.imagePaths,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.focusScale = 0.85,
    this.focusHeight = 700,
    this.onTap,
  });

  @override
  State<GroupedFocusCarouselMobile> createState() => _GroupedFocusCarouselMobileState();
}

class _GroupedFocusCarouselMobileState extends State<GroupedFocusCarouselMobile> {
  int currentFocusIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayInterval, (_) => _next());
  }

  void _resetTimer() {
    _timer?.cancel();
    _startAutoPlay();
  }

  void _next() {
    _resetTimer();
    setState(() {
      currentFocusIndex =
          (currentFocusIndex + 1) % widget.imagePaths.length;
    });
  }

  void _prev() {
    _resetTimer();
    setState(() {
      currentFocusIndex =
          (currentFocusIndex - 1 + widget.imagePaths.length) %
              widget.imagePaths.length;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.imagePaths[currentFocusIndex];
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            );
          },
          child: GestureDetector(
            key: ValueKey(currentFocusIndex),
            onTap: () => widget.onTap?.call(currentFocusIndex),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: screenWidth * widget.focusScale,
              height: widget.focusHeight,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                errorBuilder: (context, error, stackTrace) =>
                const Center(child: Icon(Icons.broken_image, size: 40)),
              ),
            ),
          ),
        ),

        Positioned(
          left: 16,
          child: _ArrowButtonMobile(
            icon: Icons.arrow_back,

            onPressed: _prev,
          ),
        ),
        Positioned(
          right: 16,
          child: _ArrowButtonMobile(
            icon: Icons.arrow_forward,
            onPressed: _next,
          ),
        ),
      ],
    );
  }
}




class LoadingLottie extends StatelessWidget {
  final double width;
  final double height;

  const LoadingLottie({
    super.key,
    this.width = 200,
    this.height = 200
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        Assets.json.jsonLoadingDot,
        width: width,
        height: height,
      ),
    );
  }
}


class TimelineIndicator extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final double lineTopHeight;
  final double lineBottomHeight;

  const TimelineIndicator({
    super.key,
    this.isFirst = false,
    this.isLast = false,
    this.lineTopHeight = 8,
    this.lineBottomHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          // Đường phía trên
          if (isFirst)
            SizedBox(
              height: lineTopHeight,
              child: VerticalDivider(
                thickness: 2,
                width: 2,
                color: !isFirst
                    ? Colors.transparent
                    : Colors.black.withOpacity(0.3),
              ),
            ),
          // Chấm tròn
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(width: 5, color: AppStyle.primaryGray90998B),
            ),
          ),
          // Đường phía dưới
          if (isLast)
            SizedBox(
              height: lineBottomHeight,
              child: VerticalDivider(
                thickness: 2,
                width: 2,
                color: !isLast
                    ? Colors.transparent
                    : Colors.black.withOpacity(0.3),
              ),
            ),
        ],
      ),
    );
  }
}

class TimelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..strokeWidth = 2;

    final paintDot = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Vẽ đường dọc
    canvas.drawLine(
        Offset(centerX, 0), Offset(centerX, size.height), paintLine);

    // Vẽ chấm tròn ở giữa
    canvas.drawCircle(Offset(centerX, centerY), 8, paintDot);

    // Vẽ viền trắng quanh chấm
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(Offset(centerX, centerY), 8, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ArrowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey[300],
          onTap: onPressed,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, size: 20),
          ),
        ),
      ),
    );
  }
}


class _ArrowButtonMobile extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ArrowButtonMobile({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.white,
        child: InkWell(
          splashColor: Colors.grey[300],
          onTap: onPressed,
          child: SizedBox(
            width: 25,
            height: 25,
            child: Icon(icon, size: 15),
          ),
        ),
      ),
    );
  }
}

class TimelineItemWidget extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String description;
  final VoidCallback onTap;
  final String imagePath;

  const TimelineItemWidget({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: AppStyle.padding_all_8(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ảnh bên trái
          if(MediaQuery.of(context).size.width > 960)
          IgnorePointer(
            ignoring: MediaQuery.of(context).size.width <= 980, // 👈 nếu đang ẩn, không cho bấm
            child: AnimatedOpacity(
              opacity: MediaQuery.of(context).size.width > 980 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1500),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  height: 217,
                  width: 35.w,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          )

          ,
          const SizedBox(width: 32),

          // Nội dung bên phải
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KSText(
                title,
                style: KSTheme.of(context).style.ts42w500.copyWith(
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 20,color:AppStyle.primaryColorBlack ,),
                  const SizedBox(width: 8),
                  KSText(
                    date,
                    style: KSTextStyle()
                        .style(14, FontWeight.w700,
                        fontBuilder: GoogleFonts.cormorantInfant)
                        .copyWith(color: AppStyle.primaryColorBlack),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 20,color:AppStyle.primaryColorBlack ,),
                  const SizedBox(width: 8),
                  KSText(
                    location,
                    style: KSTextStyle()
                        .style(14, FontWeight.w700,
                        fontBuilder: GoogleFonts.cormorantInfant)
                        .copyWith(color: AppStyle.primaryColorBlack),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              KSText(
                description,
                style: KSTextStyle()
                    .style(18, FontWeight.w500,
                    fontBuilder: GoogleFonts.cormorantInfant)
                    .copyWith(color: AppStyle.primaryGreen647B58),
              ),
              const SizedBox(height: 16),
              KSInkWellUnFocus(
                onTap: onTap,
                radius: 24,
                child: Container(
                  decoration: BoxDecoration(
                    border:
                    Border.all(width: 1, color: AppStyle.primaryColorBlack),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding:
                    AppStyle.padding_LR_16().copyWith(top: 8, bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        KSText(
                          "Xem hướng dẫn",
                          style: KSTextStyle()
                              .style(15, FontWeight.w700,
                              fontBuilder: GoogleFonts.cormorantInfant)
                              .copyWith(color: AppStyle.primaryColorBlack),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class TimelineItemWidgetMobile extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String description;
  final VoidCallback onTap;
  final String imagePath;

  const TimelineItemWidgetMobile({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: AppStyle.padding_all_8(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ảnh bên trái
          // if(MediaQuery.of(context).size.width > 960)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                height: 402,
                width: 65.w,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  // borderRadius: BorderRadius.circular(8),
                ),
              ),
            )

          ,
          const SizedBox(height: 32),

          // Nội dung bên phải
          Container(
            width: 65.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KSText(
                  title,
                  style: KSTheme.of(context).style.ts42w500.copyWith(
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 20, color: AppStyle.primaryColorBlack),
                    KSText(
                      date,
                      style: KSTextStyle()
                          .style(14, FontWeight.w700, fontBuilder: GoogleFonts.cormorantInfant)
                          .copyWith(color: AppStyle.primaryColorBlack),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Icon(Icons.location_on_outlined, size: 20, color: AppStyle.primaryColorBlack),
                    KSText(
                      location,
                      style: KSTextStyle()
                          .style(14, FontWeight.w700, fontBuilder: GoogleFonts.cormorantInfant)
                          .copyWith(color: AppStyle.primaryColorBlack),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AutoSizeText(
                      description,
                      minFontSize: 10,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: KSTextStyle()
                          .style(15.sp, FontWeight.w500,
                          fontBuilder: GoogleFonts.cormorantInfant)
                          .copyWith(color: AppStyle.primaryGreen647B58),
                    );
                  },
                )
            ,
                const SizedBox(height: 16),
                KSInkWellUnFocus(
                  onTap: onTap,
                  radius: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                      Border.all(width: 1, color: AppStyle.primaryColorBlack),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding:
                      AppStyle.padding_LR_16().copyWith(top: 8, bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          KSText(
                            "Xem hướng dẫn",
                            style: KSTextStyle()
                                .style(15, FontWeight.w700,
                                fontBuilder: GoogleFonts.cormorantInfant)
                                .copyWith(color: AppStyle.primaryColorBlack),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward, size: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}










class ExpandableRevealPanel extends StatefulWidget {
  final Widget content;
  final String blackLottieAsset;
  final String whiteLottieAsset;
  final double targetHeight;
  final Duration duration;
  final void Function()? onCollapseRequested;

  const ExpandableRevealPanel({
    super.key,
    required this.content,
    required this.blackLottieAsset,
    required this.whiteLottieAsset,
    this.onCollapseRequested,
    this.targetHeight = 400,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<ExpandableRevealPanel> createState() => ExpandableRevealPanelState();
}

class ExpandableRevealPanelState extends State<ExpandableRevealPanel>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  double _radius = 30;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
      _radius = isExpanded ? 0 : 30;

      // Future.delayed(Duration(milliseconds: 1000));

    });

    if (isExpanded) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse();
      widget.onCollapseRequested?.call();
    }
  }

  void collapse() {
    print("object");
    if (isExpanded) {
      _toggleExpand();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final height = widget.targetHeight;

    return Stack(
      children: [
        // Background container expanding
        AnimatedPositioned(
          duration: widget.duration,
          curve: Curves.easeInOut,
          top: 0,
          right: 0,
          child: AnimatedContainer(
            duration: widget.duration,
            curve: Curves.easeInOut,
            width: isExpanded ? screenWidth : 60,
            height: isExpanded ? height : 60,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(_radius),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isExpanded ? Color(0xFF647B58) : Colors.transparent,
                  // AppStyle.primaryGreen647B58
                  isExpanded ? Color(0xFF11150F) : Colors.transparent,
                  // AppStyle.primaryGreen11150F
                ],
              ),
            ),
          ),
        ),

        // Content shown after expand
        AnimatedPositioned(
          duration: widget.duration,
          top: 0,
          right: 0,
          child: IgnorePointer(
            ignoring: !isExpanded,
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: isExpanded ? 1500 : 300), // Vào chậm, ra nhanh
              tween: Tween<double>(begin: isExpanded ? 0 : 1, end: isExpanded ? 1 : 0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: SizedBox(
                width: screenWidth,
                height: height,
                child: widget.content,
              ),
            ),
          ),
        )
,

        // Lottie button with fade between black and white animation
        Positioned(
          top: 20,
          right: 20,
          child: GestureDetector(
            onTap: _toggleExpand,
            child: SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                children: [
                  // Black base icon

                  // White overlay icon with animated opacity
                  // AnimatedOpacity(
                  //   duration: widget.duration,
                  //   opacity: isExpanded ? 1 : 0,
                  //   child: Lottie.asset(
                  //     widget.whiteLottieAsset,
                  //     controller: _controller,
                  //     repeat: false,
                  //   ),
                  // ),
                  Lottie.asset(
                    widget.whiteLottieAsset,
                    controller: _controller,
                    repeat: true,
                    onLoaded: (comp) {
                      _controller.duration = comp.duration;
                    },
                  ),
                  AnimatedOpacity(
                    opacity: (!isExpanded) ? 1.0 : 0.0,
                    duration: Duration(
                      milliseconds:
                          (!isExpanded) ? 1200 : 100, // hiện ra chậm, ẩn nhanh
                    ),
                    curve: (!isExpanded) ? Curves.easeIn : Curves.fastOutSlowIn,
                    child: Lottie.asset(
                      widget.blackLottieAsset,
                      repeat: false,
                      animate: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatBubbleData {
  final String name;
  final String time;
  final String message;
  final double left;

  ChatBubbleData({
    required this.name,
    required this.time,
    required this.message,
    required this.left,
  });
}

class FlyingChatBubble extends StatefulWidget {
  final ChatBubbleData data;
  final VoidCallback? onCompleted;

  const FlyingChatBubble({
    super.key,
    required this.data,
    this.onCompleted,
  });

  @override
  State<FlyingChatBubble> createState() => _FlyingChatBubbleState();
}

class _FlyingChatBubbleState extends State<FlyingChatBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _positionAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _positionAnimation = Tween<double>(begin: 0, end: 300).animate(_controller);
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          bottom: _positionAnimation.value,
          left: widget.data.left,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: _bubbleContent(),
    );
  }

  Widget _bubbleContent() {
    final data = widget.data;
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${data.name} ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextSpan(
                  text: data.time,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.message,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}




class BubbleMenu extends StatefulWidget {
  final List<String> items;
  final List<GlobalKey> keyNav;
  final void Function(GlobalKey)? onItemTap;

  const BubbleMenu({
    super.key,
    required this.items,
    required this.keyNav,
    this.onItemTap,
  });

  @override
  State<BubbleMenu> createState() => _BubbleMenuState();
}

class _BubbleMenuState extends State<BubbleMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isOpen) {
        // 👈 mất focus → đóng menu
        _closeMenu();
      }
    });
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    setState(() => _isOpen = true);
    _controller.forward();
    FocusScope.of(context).requestFocus(_focusNode); // focus để bắt tapOutside
  }

  void _closeMenu() {
    setState(() => _isOpen = false);
    _controller.reverse();
    _focusNode.unfocus(); // bỏ focus khi đóng
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMenuItem(String text, GlobalKey keyNav, int index) {
    const double offsetX = 60.0;
    final double offsetY = 55.0 * index;
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(offsetX * _controller.value, offsetY * _controller.value),
              child: Opacity(opacity: _controller.value, child: child),
            );
          },
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: GestureDetector(
              onTap: () {
                widget.onItemTap?.call(keyNav);
                _closeMenu(); // chọn xong đóng menu
              },
              child: AnimatedScale(
                scale: isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? AppStyle.primaryGreen_0_81_49.withOpacity(0.2)
                        : AppStyle.primaryGreen_0_81_49.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: AppStyle.primaryGreen_0_81_49,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: SizedBox(
        height: widget.items.length * 50,
        child: Stack(
          alignment: Alignment.topLeft,
          clipBehavior: Clip.none,
          children: [
            // menu con
            ...List.generate(
              widget.items.length,
                  (i) => _buildMenuItem(widget.items[i], widget.keyNav[i], i),
            ),

            // nút chính
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleMenu,
                customBorder: const CircleBorder(),
                splashColor: AppStyle.primaryGreen_0_81_49.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    Assets.svg.svgMenu.keyName,
                    color: AppStyle.primaryGreen_0_81_49,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class BubbleMenuMobile extends StatefulWidget {
  final List<String> items;
  final List<GlobalKey> keyNav;
  final void Function(GlobalKey)? onItemTap;

  const BubbleMenuMobile({
    super.key,
    required this.items,
    required this.keyNav,
    this.onItemTap,
  });

  @override
  State<BubbleMenuMobile> createState() => _BubbleMenuMobileState();
}

class _BubbleMenuMobileState extends State<BubbleMenuMobile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isOpen) {
        // 👈 mất focus → đóng menu
        _closeMenu();
      }
    });
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    setState(() => _isOpen = true);
    _controller.forward();
    FocusScope.of(context).requestFocus(_focusNode); // focus để bắt tapOutside
  }

  void _closeMenu() {
    setState(() => _isOpen = false);
    _controller.reverse();
    _focusNode.unfocus(); // bỏ focus khi đóng
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMenuItem(String text, GlobalKey keyNav, int index) {
    const double offsetX = 60.0;
    final double offsetY = 55.0 * index;
    bool isHovered = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(offsetX * _controller.value, offsetY * _controller.value),
              child: Opacity(opacity: _controller.value, child: child),
            );
          },
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: GestureDetector(
              onTap: () {
                widget.onItemTap?.call(keyNav);
                _closeMenu(); // chọn xong đóng menu
              },
              child: AnimatedScale(
                scale: isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: isHovered
                        ? AppStyle.primaryGreen_0_81_49.withOpacity(0.2)
                        : AppStyle.whiteBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: AppStyle.primaryGreen_0_81_49,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: SizedBox(
        height: widget.items.length * 50,
        child: Stack(
          alignment: Alignment.topLeft,
          clipBehavior: Clip.none,
          children: [
            // menu con
            ...List.generate(
              widget.items.length,
                  (i) => _buildMenuItem(widget.items[i], widget.keyNav[i], i),
            ),

            // nút chính
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _toggleMenu,
                customBorder: const CircleBorder(),
                splashColor: AppStyle.primaryGreen_0_81_49.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    Assets.svg.svgMenu.keyName,
                    color: AppStyle.primaryGreen_0_81_49,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartHoverMenuWidget extends StatefulWidget {
  final List<Widget> items;
  final Widget icon; // icon tùy chỉnh

  const CartHoverMenuWidget({
    super.key,
    required this.items,
    required this.icon,
  });

  @override
  State<CartHoverMenuWidget> createState() => _CartHoverMenuWidgetState();
}

class _CartHoverMenuWidgetState extends State<CartHoverMenuWidget> {
  OverlayEntry? _overlayEntry;
  bool _hovering = false;

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;
    const menuWidth = 300.0;
    double left = offset.dx -350;

    // dịch menu nếu tràn ra ngoài màn hình
    if (left + menuWidth > screenWidth - 10) left = screenWidth - menuWidth - 10;
    if (left < 10) left = 10;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: left,
        top: offset.dy + renderBox.size.height + 5,
        // width: menuWidth,
        child: MouseRegion(
          onEnter: (_) => _setHover(true),
          onExit: (_) => _setHover(false),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // CustomPaint(
                //   painter: _TrianglePainter(),
                //   child: const SizedBox(height: 10, width: 20),
                // ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: _hovering ? 1 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...widget.items,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _setHover(bool value) {
    _hovering = value;
    if (_hovering) {
      setState(() {});
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (!_hovering) _removeOverlay();
      });
    }
    FocusScope.of(context).unfocus();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _setHover(true);
        _showOverlay(context);
      },
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showOverlay(context);
            _setHover(true);
          } else {
            _removeOverlay();
          }
        },
        child: widget.icon,
      ),
    );
  }

}
class CartClickMenuWidget extends StatefulWidget {
  final List<Widget> items;
  final Widget icon;

  const CartClickMenuWidget({
    super.key,
    required this.items,
    required this.icon,
  });

  @override
  State<CartClickMenuWidget> createState() => _CartClickMenuWidgetState();
}

class _CartClickMenuWidgetState extends State<CartClickMenuWidget> {
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleMenu(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay(context);
    }
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;
     double menuWidth = 100.w < 400 ?  80.w:400;
     print(menuWidth);
    double left = offset.dx ;

    if (left + menuWidth > screenWidth - 10) left = screenWidth - menuWidth - 10;
    if (left < 10) left = 10;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: left,
        top: offset.dy + renderBox.size.height + 5,
        child: Material(
          color: Colors.transparent,
          child: Container(

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.items,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _toggleMenu(context),
      icon: widget.icon,
    );
  }
}

/// Vẽ tam giác nhọn hướng lên
class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);

    // đổ bóng nhẹ
    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 3, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MessengerButton extends StatelessWidget {
  final String username; // Username hoặc ID Facebook
  final String Function() message;  // Nội dung sẵn

  const MessengerButton({
    super.key,
    required this.username,
    required this.message,
  });


  void _openMessenger() async {


    // Copy nội dung message vào clipboard
    await Clipboard.setData(ClipboardData(text: message()));


    final url = 'https://zalo.me/$username';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Không thể mở link Zalo');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: S.current.paste, // chú thích khi hover
      child: ElevatedButton(
        onPressed: _openMessenger,
        style: ElevatedButton.styleFrom(
          side: BorderSide.none,
          elevation: 0,
          backgroundColor: AppStyle.primaryGreen_0_81_49,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child:   Text(S.current.zalo,  style: KSTheme.of(context).style.ts14w500.copyWith(fontFamily: FontFamily.roboto, color: AppStyle.whiteBg),),
      ),
    );

  }
}