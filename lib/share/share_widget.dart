import 'dart:async';
import 'dart:developer';
import 'dart:math' as cal;
import 'package:float_bubble/float_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xanh_coffee/generated/fonts.gen.dart';
import 'package:xanh_coffee/helper/format/helper.dart';
import 'package:xanh_coffee/helper/save_data/appsetting.dart';

import 'package:xanh_coffee/share/base_provider/pull_load_more.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:xanh_coffee/share/share_on_app.dart';

import 'package:xanh_coffee/share/size_configs.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
import 'package:xanh_coffee/share/text_style.dart';
import '../generated/assets.gen.dart';
import '../router/router_app.dart';
import '../router/router_string.dart';

import '../theme/ks_theme.dart';
import 'app_styles.dart';

import 'base_provider/pull_load_mores.dart';

// import 'package:pattern_formatter/pattern_formatter.dart';
class KSLoadingIndicator extends StatelessWidget {
  const KSLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: const SizedBox(
              width: 120,
              height: 120,
              child: CupertinoActivityIndicator(
                radius: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
}

class KSWindowAreaFittedBox extends StatelessWidget {
  final bool fitTop;
  final bool fitBottom;
  final bool fitLeft;
  final bool fitRight;
  final Color? color;

  const KSWindowAreaFittedBox({this.fitTop = false,
    this.fitBottom = false,
    this.fitLeft = false,
    this.fitRight = false,
    this.color = Colors.transparent,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final padding = media.padding;
    final size = media.size;
    if (fitTop) {
      return _fitBox(size.width, padding.top);
    } else if (fitBottom) {
      return _fitBox(size.width, padding.bottom);
    } else if (fitLeft) {
      return _fitBox(padding.left, null);
    } else if (fitRight) {
      return _fitBox(padding.right, null);
    }
    return Container();
  }

  Widget _fitBox(double width, double? height) =>
      Container(
        width: width,
        height: height,
        color: color!,
      );
}

class KSScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Function? onBack;
  final Widget? bottomNavigationBar;
  final SystemUiOverlayStyle systemUiOverlayStyle;
  final EdgeInsets padding;
  final Color? statusBarBackgroundColor;
  final bool safeAreaTop;
  final bool safeAreaLeft;
  final bool safeAreaRight;
  final bool safeAreaBottom;
  final PreferredSizeWidget? appbar;
  final bool isDisableFitTop;
  final bool isFitTopAppbar;
  final bool isDisableFitBottom;
  final bool isFitBottomNav;
  final Widget? floatingActionButton;

  const KSScaffold({required this.child,
    this.floatingActionButton,
    this.backgroundColor,
    this.onTap,
    this.onBack,
    this.bottomNavigationBar,
    this.systemUiOverlayStyle = SystemUiOverlayStyle.light,
    this.padding = EdgeInsets.zero,
    this.statusBarBackgroundColor,
    this.safeAreaTop = false,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.safeAreaBottom = false,
    this.isDisableFitTop = false,
    this.isDisableFitBottom = false,
    this.isFitTopAppbar = false,
    this.isFitBottomNav = false,
    this.appbar,
    Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      AnnotatedRegion(
        value: systemUiOverlayStyle,
        child: WillPopScope(
          onWillPop: () async {
            FocusScope.of(context).unfocus();
            onBack?.call();

            return true;
          },
          child: Scaffold(
            // resizeToAvoidBottomInset: false,
            appBar: appbar,
            backgroundColor: backgroundColor ?? Colors.white,
            body: Padding(
              padding: EdgeInsets.only(
                  top: !isFitTopAppbar
                      ? 0.0
                      : AppSetting.instance.ios
                      ? 50
                      : 40),
              child: Column(
                children: [
                  if (!isDisableFitTop) ...[
                    KSWindowAreaFittedBox(
                      fitTop: true,
                      color: statusBarBackgroundColor ?? AppStyle.primaryColor,
                    )
                  ],
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          onTap?.call();
                        },
                        child: SafeArea(
                            top: safeAreaTop,
                            left: safeAreaLeft,
                            right: safeAreaRight,
                            bottom: safeAreaBottom,
                            child: Container(
                                padding: padding,
                                color: Colors.transparent,
                                child: child))),
                  ),
                ],
              ),
            ),
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: bottomNavigationBar,
          ),
        ),
      );
}

class KSButton extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? fontColor;
  final Color border;
  final FontWeight fontWeight;
  final double fontSize;
  final double height;
  final double radius;
  final bool isSelected;
  final bool lock;
  final String? icon;
  final void Function()? onTap;

  KSButton(this.title, {
    super.key,
    this.onTap,
    this.isSelected = false,
    this.backgroundColor = Colors.transparent,
    this.fontColor = Colors.white,
    this.fontSize = 24,
    this.height = 6.5,
    this.radius = 8,
    this.border = Colors.transparent,
    this.icon,
    this.fontWeight = FontWeight.w500,
    this.lock = false, // Thêm thuộc tính lock, mặc định là false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: lock
            ? AppStyle.whiteBg
            : (backgroundColor == Colors.transparent
            ? backgroundColor
            : backgroundColor),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: lock ? AppStyle.primaryGray : border,
          width: 1.0,
        ),
      ),
      child: KSInkWellUnFocus(
        radius: 8,
        onTap: lock
            ? null // Nếu lock = true, vô hiệu hóa onTap
            : () async {
          FocusScope.of(context).unfocus();
          // loadDataWithLoading();
          // await loadDataWithLoading(
          //   action: () async {
          //     onTap
          //         ?.call(); // ✅ Hàm TestBug được chạy sau khi loading hiển thị xong
          //   },
          // );
          onTap
              ?.call();
        },
        child: Padding(
          padding: const EdgeInsets.all(0.0).copyWith(left: 8, right: 8),
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  SvgPicture.asset(
                    height: 22,
                    width: 22,
                    color: lock ? AppStyle.primaryGray : AppStyle.primaryColor,
                    icon!,
                  ),
                // const SizedBox(width: 8),
                Text(title,
                    textAlign: TextAlign.center,
                    style: KSTheme
                        .of(context)
                        .style
                        .ts15w500
                        .copyWith(
                      fontFamily: FontFamily.roboto,
                      color: lock ? AppStyle.primaryGrayWord : fontColor,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KSShadow extends StatelessWidget {
  Widget child;
  Offset direction;
  double radius;
  Color color;
  double line;
  Color lineColor;

  KSShadow({required this.child,
    this.direction = Offset.zero,
    this.radius = 0,
    this.color = Colors.white,
    this.line = 0,
    this.lineColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: line, color: lineColor),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(27, 0, 0, 0),
            blurRadius: 12,
            offset: this.direction, // Shadow position
          ),
        ],
      ),
      child: child,
    );
  }
}

class KSShadowCircleLeft extends StatelessWidget {
  Widget child;
  Offset direction;
  double radius;
  Color color;

  KSShadowCircleLeft({required this.child,
    this.direction = Offset.zero,
    this.radius = 0,
    this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24), topLeft: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(27, 0, 0, 0),
            blurRadius: 12,
            offset: this.direction, // Shadow position
          ),
        ],
      ),
      child: child,
    );
  }
}

class KSNotificationAlert extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String button1Text;
  final String button2Text;
  final VoidCallback onButton1Pressed;
  final VoidCallback onButton2Pressed;

  KSNotificationAlert({
    required this.title,
    required this.imageUrl,
    required this.button1Text,
    required this.button2Text,
    required this.onButton1Pressed,
    required this.onButton2Pressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            KSText(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Image
            Image.network(
              imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            // Buttons
            Column(
              children: [
                ElevatedButton(
                  onPressed: onButton1Pressed,
                  child: KSText(button1Text),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: onButton2Pressed,
                  child: KSText(button2Text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Phương thức tĩnh để hiển thị thông báo
  static void show({
    required BuildContext context,
    required String title,
    required String imageUrl,
    required String button1Text,
    required String button2Text,
    required VoidCallback onButton1Pressed,
    required VoidCallback onButton2Pressed,
  }) {
    showDialog(
      context: context,
      builder: (context) =>
          KSNotificationAlert(
            title: title,
            imageUrl: imageUrl,
            button1Text: button1Text,
            button2Text: button2Text,
            onButton1Pressed: onButton1Pressed,
            onButton2Pressed: onButton2Pressed,
          ),
    );
  }
}

void KSshowCustomDialog({
  required BuildContext context,
  required String imageAsset,
  required String title,
  String? successMessage,
  String? titleOne = "Tiếp tục",
  String? titleTwo = "Trang chủ",
  String? detail,
  String? errorsMessage,
  String? dangerMessage,
  VoidCallback? onContinue,
  VoidCallback? onHome,
}) {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  showDialog<void>(
    context: context,
    barrierDismissible: false, // Người dùng phải nhấn nút để đóng
    builder: (BuildContext context) {
      return Center(
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Bo góc hộp thoại
          ),
          contentPadding: EdgeInsets.zero,
          // Xóa padding mặc định
          content: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  // Giao diện gọn gàng
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(imageAsset, height: 20.h, width: 100.h),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: KSTheme
                          .of(context)
                          .style
                          .ts20w700,
                    ),
                    const SizedBox(height: 8),
                    if (successMessage != null)
                      Text(
                        successMessage.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: KSTheme
                            .of(context)
                            .style
                            .ts20w700
                            .copyWith(color: AppStyle.primaryColor),
                      ),
                    if (errorsMessage != null)
                      Text(
                        errorsMessage.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: KSTheme
                            .of(context)
                            .style
                            .ts20w700
                            .copyWith(color: AppStyle.primaryRedOr),
                      ),
                    if (dangerMessage != null)
                      Text(
                        dangerMessage.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: KSTheme
                            .of(context)
                            .style
                            .ts20w700
                            .copyWith(color: AppStyle.primaryYellowFAAD14),
                      ),
                    if (detail != null)
                      Text(
                        detail,
                        textAlign: TextAlign.center,
                        style: KSTheme
                            .of(context)
                            .style
                            .ts16w400
                            .copyWith(color: AppStyle.primaryColorBlack),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Màu nền mờ
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close,
                        color: Colors.black, size: 20), // Dấu "X"
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: KSButton(
                    titleOne!,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      onContinue != null
                          ? onContinue()
                          : Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: KSButton(
                    titleTwo!,
                    backgroundColor: AppStyle.whiteBg,
                    fontColor: AppStyle.primaryColor,
                    onTap: () {
                      onHome != null
                          ? onHome()
                          : navigatorKey.currentState
                          ?.popUntil((route) => route.isFirst);
                      ;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class KSStyledSwitch extends StatefulWidget {
  final void Function(bool isToggled) onToggled;
  final bool initialToggled;
  final bool? auto;

  const KSStyledSwitch({
    Key? key,
    required this.onToggled,
    required this.initialToggled,
    required this.auto,
  }) : super(key: key);

  @override
  State<KSStyledSwitch> createState() => _KSStyledSwitchState();
}

class _KSStyledSwitchState extends State<KSStyledSwitch> {
  late bool isToggled;
  double size = 25;
  double innerPadding = 0;

  @override
  void initState() {
    super.initState();
    innerPadding = size / 10;
    isToggled = widget.initialToggled;
  }

  @override
  void didUpdateWidget(covariant KSStyledSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialToggled != oldWidget.initialToggled) {
      setState(() {
        isToggled = widget.initialToggled;
      });
    }
  }

  void setToggleState(bool value) {
    if (widget.auto == false) {
      setState(() {
        isToggled = value;
      });
      widget.onToggled(isToggled);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setToggleState(!isToggled);
      },
      onPanEnd: (b) {
        setToggleState(!isToggled);
      },
      child: AnimatedContainer(
        height: size,
        width: size * 2,
        padding: EdgeInsets.all(innerPadding),
        alignment: isToggled ? Alignment.centerRight : Alignment.centerLeft,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: !isToggled ? Colors.grey.shade300 : AppStyle.primaryColor,
        ),
        child: Container(
          width: size - innerPadding * 2,
          height: size - innerPadding * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: !isToggled ? Colors.white : AppStyle.whiteBg,
          ),
        ),
      ),
    );
  }
}

class DaySwitchExpansion extends StatefulWidget {
  final String day;
  final bool autoON;
  final Widget? child;
  final void Function(bool isToggled) onToggled;
  final bool isExpanded;
  final void Function(bool)? onSetExpanded; // Callback function from the parent

  const DaySwitchExpansion({
    Key? key,
    required this.day,
    required this.onToggled,
    required this.autoON,
    this.child,
    this.isExpanded = false,
    this.onSetExpanded, // Receive callback
  }) : super(key: key);

  @override
  _DaySwitchExpansionState createState() => _DaySwitchExpansionState();
}

class _DaySwitchExpansionState extends State<DaySwitchExpansion> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
  }

  void setExpanded(bool value) {
    setState(() {
      isExpanded = value;
    });
    widget.onToggled(value);
  }

  void toggleSwitch(bool value) {
    setExpanded(value);
  }

  @override
  Widget build(BuildContext context) {
    // Trigger onSetExpanded callback
    widget.onSetExpanded?.call(isExpanded);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            KSText(
              widget.day,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            KSStyledSwitch(
              auto: widget.autoON,
              onToggled: toggleSwitch,
              initialToggled: isExpanded,
            ),
          ],
        ),
        if (widget.child != null && isExpanded)
          Visibility(
            visible: isExpanded,
            maintainState: true,
            maintainAnimation: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: widget.child,
            ),
          ),
      ],
    );
  }
}

class DaySwitchExpansionTrue extends StatefulWidget {
  final String day;
  final bool autoON;
  final Widget? child;
  final void Function(bool isToggled) onToggled;
  final bool isExpanded;
  final void Function(bool)? onSetExpanded; // Callback function from the parent

  const DaySwitchExpansionTrue({
    Key? key,
    required this.day,
    required this.onToggled,
    required this.autoON,
    this.child,
    this.isExpanded = false,
    this.onSetExpanded, // Receive callback
  }) : super(key: key);

  @override
  _DaySwitchExpansionTrueState createState() => _DaySwitchExpansionTrueState();
}

class _DaySwitchExpansionTrueState extends State<DaySwitchExpansionTrue> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            KSText(
              widget.day,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            KSStyledSwitch(
              auto: widget.autoON,
              onToggled: (bool value) {
                widget.onToggled(value);
              },
              initialToggled: widget.isExpanded, // Sử dụng widget.isExpanded
            ),
          ],
        ),
        if (widget.child != null && widget.isExpanded)
          Visibility(
            visible: widget.isExpanded,
            maintainState: true,
            maintainAnimation: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: widget.child,
            ),
          ),
      ],
    );
  }
}

class KSSearchBox extends StatefulWidget {
  TextEditingController? controller;
  bool isAutocomplete;
  bool enableClearButton;
  bool enableAnimationSubmit;
  bool filter;
  int minKeywordSearch;
  Color? backgroundColor;
  String hint;
  int delayTypingSubmit;
  bool? border;
  void Function(String)? onSubmit;
  void Function(String)? onChange;

  KSSearchBox({super.key,
    this.hint = 'Tìm kiếm ngay....',
    this.onChange,
    this.onSubmit,
    this.isAutocomplete = true,
    this.minKeywordSearch = 4,
    this.delayTypingSubmit = 1200,
    this.controller,
    this.backgroundColor,
    this.border = false,
    this.enableClearButton = false,
    this.filter = false,
    this.enableAnimationSubmit = false});

  @override
  State<KSSearchBox> createState() => _KSSearchBoxState();
}

class _KSSearchBoxState extends State<KSSearchBox> {
  double animationWithValue = 0;
  bool isAnimated = false;
  bool isDisplayButtonClear = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? '#FFFFFF'.toColor(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 375),
            curve: Curves.easeInCubic,
            width: animationWithValue,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          TextField(
            autofocus: false,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: (value) => autocomplete(value, context),
            onSubmitted: (value) {
              onBeforeSubmit(value);
            },
            textInputAction: TextInputAction.go,
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(Icons.search),
              ),
              suffixIconConstraints: const BoxConstraints(maxWidth: 38),
              suffixIcon: Visibility(
                visible: isDisplayButtonClear,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    widget.controller!.clear();
                    isDisplayButtonClear = false;
                    onBeforeSubmit("");
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black54,
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  color: widget.border! == false
                      ? Colors.grey.shade400
                      : Colors.white,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(
                  color: widget.border! == false
                      ? Colors.grey.shade400
                      : Colors.white,
                  width: 1.0,
                ),
              ),
              hintText: widget.hint,
              hintStyle: KSTheme
                  .of(context)
                  .style
                  .ts14w400,
            ),
          )
        ],
      ),
    );
  }

  Timer? timerAutocomplete;

  void autocomplete(String value, context) {
    if (widget.onChange != null && !widget.isAutocomplete) {
      widget.onChange!(value);
    }

    if (!widget.isAutocomplete) return;

    if (timerAutocomplete != null) {
      log('autoComple.cancel reset timer');
      timerAutocomplete!.cancel();
    }

    if ((value.isEmpty && isDisplayButtonClear ||
        value.isNotEmpty && !isDisplayButtonClear)) {
      isDisplayButtonClear = !isDisplayButtonClear;
      setState(() {});
      log('autoComple.display button clear ${isDisplayButtonClear
          ? 'hiển thị'
          : 'ẩn'}');
    }

    if (value.length < widget.minKeywordSearch) {
      return;
    }

    timerAutocomplete = Timer.periodic(
        Duration(milliseconds: widget.delayTypingSubmit), (timer) {
      log('autoComple.cancel submit text');
      onBeforeSubmit(value);

      // hidden keyboard
      FocusScope.of(context).unfocus();
      timer.cancel();
    });
  }

  void onBeforeSubmit(value) {
    needRunAnimation();
    if (widget.onSubmit != null) widget.onSubmit!(value);
  }

  void needRunAnimation() async {
    if (widget.enableAnimationSubmit) {
      animationWithValue = MediaQuery
          .of(context)
          .size
          .width;
      isAnimated = !isAnimated;
      setState(() {});

      await Future.delayed(const Duration(milliseconds: 500));
      animationWithValue = 0;
      isAnimated = !isAnimated;
      setState(() {});
    }
  }
}

class KSSliverAppBar extends StatelessWidget {
  final String backText;
  final String iconPath;
  final Color backgroundColor;
  final TextStyle textStyle;
  final VoidCallback? onBackTap;

  const KSSliverAppBar({
    Key? key,
    required this.backText,
    required this.iconPath,
    required this.backgroundColor,
    required this.textStyle,
    this.onBackTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: backgroundColor,
      leadingWidth: 140,
      // expandedHeight: 50,
      leading: KSInkWellUnFocus(
        onTap: onBackTap ?? () => Navigator.of(context).pop(),
        child: Padding(
          padding: AppStyle.padding_LR_16(),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath, // This allows you to pass the icon dynamically
                width: 21,
                height: 21,
              ),
              const SizedBox(width: 8),
              KSText(
                backText,
                style: textStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> KSshowAlertIOS(BuildContext _context, String title, String message,
    {bool? autoPop, void Function()? onTap, bool? oneButton}) async {
  final _context = navigatorKey.currentContext;
  if (_context == null) return;

  await showCupertinoDialog(
      context: _context!,
      builder: (context) =>
          CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (oneButton == null)
                CupertinoButton(
                    child: Text(onTap != null ? "Không" : "Đồng ý"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              if (onTap != null)
                CupertinoButton(
                    child: const Text('Có'),
                    onPressed: () {
                      if (autoPop == true) {
                        Navigator.pop(context);
                      }
                      onTap();
                      Navigator.pop(context);
                    })
            ],
          ));

  // if (onTap != null) {
  //   onTap();
  // }
}

Future<void> KSshowAlertIOSNotContext(String title, String message,
    {bool? autoPop, void Function()? onTap, bool? oneButton}) async {
  final _context = navigatorKey.currentContext;
  if (_context == null) return;

  await showCupertinoDialog(
      context: _context!,
      builder: (context) =>
          CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (oneButton == null)
                CupertinoButton(
                    child: Text(onTap != null ? "Không" : "Đồng ý"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              if (onTap != null)
                CupertinoButton(
                    child: const Text('Có'),
                    onPressed: () {
                      if (autoPop == true) {
                        Navigator.pop(context);
                      }
                      onTap();
                      Navigator.pop(context);
                    })
            ],
          ));

  // if (onTap != null) {
  //   onTap();
  // }
}

@immutable
class KSLoadingDot extends StatelessWidget {
  KSLoadingDot(
      {super.key, this.text = 'Đang tải dữ liệu', this.style, this.linkLogo});

  String? text;
  TextStyle? style;
  String? linkLogo;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (linkLogo != null)
              Transform.scale(
                  scale: 2,
                  child: Image.network(
                    linkLogo!,
                    width: 150,
                    height: 150,
                  )),
            ColorLoader3(
              radius: 10,
              dotRadius: 6.0,
              centerDot: false,
              dotColor2: AppStyle.primaryColor,
              dotColor: AppStyle.primaryColor,
              dotQuality: 8,
            ),
            KSText(
              text!,
              style: style ??
                  KSTheme
                      .of(context)
                      .style
                      .ts12w700
                      .copyWith(color: AppStyle.primaryColor),
            )
          ],
        ));
  }
}

class ColorLoader2 extends StatefulWidget {
  final Color color1;
  final Color color2;
  final Color color3;

  const ColorLoader2({super.key,
    this.color1 = Colors.deepOrangeAccent,
    this.color2 = Colors.yellow,
    this.color3 = Colors.lightGreen});

  @override
  _ColorLoader2State createState() => _ColorLoader2State();
}

class _ColorLoader2State extends State<ColorLoader2>
    with TickerProviderStateMixin {
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;

  @override
  void initState() {
    super.initState();

    controller1 = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);

    controller2 = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);

    controller3 = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller1,
        curve: const Interval(0.0, 1.0, curve: Curves.linear)));

    animation2 = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: controller2,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn)));

    animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller3,
        curve: const Interval(0.0, 1.0, curve: Curves.decelerate)));

    controller1.repeat();
    controller2.repeat();
    controller3.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(
          children: <Widget>[
            RotationTransition(
              turns: animation1,
              child: CustomPaint(
                painter: Arc1Painter(widget.color1),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
            RotationTransition(
              turns: animation2,
              child: CustomPaint(
                painter: Arc2Painter(widget.color2),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
            RotationTransition(
              turns: animation3,
              child: CustomPaint(
                painter: Arc3Painter(widget.color3),
                child: const SizedBox(
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }
}

class Arc1Painter extends CustomPainter {
  final Color color;

  Arc1Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p1 = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect1 = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    canvas.drawArc(rect1, 0.0, 0.5 * cal.pi, false, p1);
    canvas.drawArc(rect1, 0.6 * cal.pi, 0.8 * cal.pi, false, p1);
    canvas.drawArc(rect1, 1.5 * cal.pi, 0.4 * cal.pi, false, p1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc2Painter extends CustomPainter {
  final Color color;

  Arc2Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p2 = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect2 = Rect.fromLTWH(
        0.0 + (0.2 * size.width) / 2,
        0.0 + (0.2 * size.height) / 2,
        size.width - 0.2 * size.width,
        size.height - 0.2 * size.height);

    canvas.drawArc(rect2, 0.0, 0.5 * cal.pi, false, p2);
    canvas.drawArc(rect2, 0.8 * cal.pi, 0.6 * cal.pi, false, p2);
    canvas.drawArc(rect2, 1.6 * cal.pi, 0.2 * cal.pi, false, p2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc3Painter extends CustomPainter {
  final Color color;

  Arc3Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p3 = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect3 = Rect.fromLTWH(
        0.0 + (0.4 * size.width) / 2,
        0.0 + (0.4 * size.height) / 2,
        size.width - 0.4 * size.width,
        size.height - 0.4 * size.height);

    canvas.drawArc(rect3, 0.0, 0.9 * cal.pi, false, p3);
    canvas.drawArc(rect3, 1.1 * cal.pi, 0.8 * cal.pi, false, p3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ColorLoader3 extends StatefulWidget {
  final double radius;
  final double dotRadius;
  final Color? dotColor;
  final Color? dotColor2;
  final bool centerDot;
  final int dotQuality;

  const ColorLoader3({super.key,
    this.radius = 30.0,
    this.dotRadius = 3.0,
    this.centerDot = true,
    this.dotColor = Colors.white,
    this.dotColor2 = Colors.yellow,
    this.dotQuality = 0});

  @override
  _ColorLoader3State createState() => _ColorLoader3State();
}

class _ColorLoader3State extends State<ColorLoader3>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation_rotation;
  late AnimationController controller;

  late double radius;
  late double dotRadius;

  late int visibleDotCount; // Number of visible dots
  int time = 3000;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;
    visibleDotCount = widget.dotQuality;
    controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    animation_rotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          visibleDotCount++; // Show the next dot
          if (visibleDotCount <= 8) {
            controller.forward(from: 0.0); // Start the animation again
          } else {
            controller.repeat(); // Repeat the rotation animation
          }
        });
      }
    });

    controller.forward(); // Start the loading animation
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      height: 100.0,
      child: Center(
        child: RotationTransition(
          turns: animation_rotation,
          child: Stack(
            children: <Widget>[
              if (widget.centerDot)
                Transform.translate(
                  offset: const Offset(0.0, 0.0),
                  child: Dot(
                    radius: radius,
                    color: widget.dotColor,
                  ),
                ),
              for (var i = 0; i < 8; i++)
                if (i < visibleDotCount)
                  Transform.translate(
                    offset: Offset(
                      (radius + 10) * cal.cos(i * cal.pi / 4),
                      (radius + 10) * cal.sin(i * cal.pi / 4),
                    ),
                    child: Dot(
                      radius: dotRadius,
                      color: i % 2 == 0 ? widget.dotColor : widget.dotColor2,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double? radius;
  final Color? color;

  const Dot({super.key, this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

class KSRow extends StatelessWidget {
  KSRow({
    this.amount,
    this.title,
    this.child,
    this.topping,
    this.note,
    this.padding,
  });

  EdgeInsets? padding;
  Widget? amount;
  Widget? title;
  Widget? child;
  String? topping;
  String? note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null ? const EdgeInsets.only(bottom: 16) : padding!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 40),
                    child: (amount != null) ? amount! : Container(),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  if (title != null) title!,
                ],
              ),
              if (child != null) child!
            ],
          ),
          if (topping != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  KSText(topping!,
                      style: KSTheme
                          .of(context)
                          .style
                          .ts12w400
                          .copyWith(color: AppStyle.primaryGrayWord)),
                ],
              ),
            ),
          if (note != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  // SvgPicture.asset(Assets.icons.icNote.keyName),
                  const SizedBox(
                    width: 8,
                  ),
                  KSText(
                    note!,
                    style: KSTheme
                        .of(context)
                        .style
                        .ts12w400
                        .copyWith(color: AppStyle.primaryGrayWord),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class KSRowText extends StatelessWidget {
  KSRowText(this.amount,
      this.title,
      this.value, {
        this.note,
        this.topping,
        this.styleTitle,
        this.styleValue,
        this.padding = null,
      });

  String title, value;

  String? note, topping, amount;
  TextStyle? styleValue, styleTitle;
  EdgeInsets? padding = const EdgeInsets.only(left: 0);

  @override
  Widget build(BuildContext context) {
    return KSRow(
      padding: padding,
      amount: KSText(
        "$amount x",
        textAlign: TextAlign.end,
        style: styleTitle == null
            ? KSTheme
            .of(context)
            .style
            .ts14w500
            : styleTitle,
      ),
      title: Column(
        children: [
          KSText(
            title,
            style: styleTitle == null
                ? KSTheme
                .of(context)
                .style
                .ts14w500
                : styleTitle,
          ),
        ],
      ),
      child: KSText(
        double.parse(value).toCurrency(),
        style: styleValue == null
            ? KSTheme
            .of(context)
            .style
            .ts14w500
            .copyWith(fontWeight: FontWeight.w600)
            : styleValue,
      ),
      topping: topping,
      note: note,
    );
  }
}

class DMCLRowCus extends StatelessWidget {
  DMCLRowCus({
    this.title,
    this.child,
    this.start,
    this.padding,
  });

  EdgeInsets? padding;
  bool? start;
  Widget? title;
  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null ? const EdgeInsets.only(bottom: 8) : padding!,
      child: Row(
        crossAxisAlignment: start == false
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [if (title != null) title!, if (child != null) child!],
      ),
    );
  }
}

class DMCLRowTextCus extends StatelessWidget {
  DMCLRowTextCus(this.title, this.value,
      {this.styleTitle, this.color, this.styleValue, this.padding = null});

  String title, value;
  TextStyle? styleValue, styleTitle;
  EdgeInsets? padding;
  Color? color = AppStyle.primaryGrayWord;

  @override
  Widget build(BuildContext context) {
    return DMCLRowCus(
        start: false,
        padding: padding,
        title: Flexible(
          child: KSText(
            title,
            style: styleTitle == null
                ? KSTheme
                .of(context)
                .style
                .ts16w500
                .copyWith(color: color)
                : styleTitle,
          ),
        ),
        child: Flexible(
          // child: KSText(
          //   textAlign: TextAlign.end,
          //   value,
          //   style: styleValue == null
          //       ? KSTheme.of(context).style.ts16w500
          //       : styleValue,
          // ),
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: styleValue == null
                ? KSTheme
                .of(context)
                .style
                .ts16w500
                : styleValue,
            // minFontSize: 18,
          ),
        ));
  }
}

class DMCLRowTexExpand extends StatelessWidget {
  DMCLRowTexExpand(this.title, this.value,
      {this.styleTitle, this.color, this.styleValue, this.padding = null});

  String title, value;
  TextStyle? styleValue, styleTitle;
  EdgeInsets? padding;
  Color? color = AppStyle.primaryGrayWord;

  @override
  Widget build(BuildContext context) {
    return DMCLRowCus(
        start: true,
        padding: padding,
        title: Flexible(
          child: KSText(
            title,
            style: styleTitle == null
                ? KSTheme
                .of(context)
                .style
                .ts16w500
                .copyWith(color: color)
                : styleTitle,
          ),
        ),
        child: Flexible(
          flex: 2,

          child: KSText(
            textAlign: TextAlign.end,
            value,
            style: styleValue == null
                ? KSTheme
                .of(context)
                .style
                .ts16w500
                : styleValue,
          ),
          // child: AutoSizeText(
          //   value,
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          //     style: styleValue == null
          //         ? KSTheme.of(context).style.ts16w500
          //         : styleValue,
          //   minFontSize: 18,
          // ),
        ));
  }
}

class KSShadowBox extends StatelessWidget {
  Widget child;
  Offset direction;
  double radius;

  KSShadowBox({super.key,
    required this.child,
    this.direction = Offset.zero,
    this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(27, 0, 0, 0),
            blurRadius: 12,
            offset: this.direction, // Shadow position
          ),
        ],
      ),
      child: child,
    );
  }
}

class KSInkWellUnFocus extends StatelessWidget {
  Widget child;
  void Function()? onTap;
  double radius;
  bool sameColor;

  KSInkWellUnFocus({super.key,
    required this.child,
    this.radius = 0,
    this.onTap,
    this.sameColor = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          splashColor:
          !sameColor ? AppStyle.primaryColor.withOpacity(0.2) : null,
          highlightColor:
          !sameColor ? AppStyle.primaryColor.withOpacity(0.2) : null,
          onTap: () {
            FocusScope.of(context).unfocus();
            onTap?.call();
          },
          child: child),
    );
  }
}

class KSFloatingDebugButton extends StatelessWidget {
  final bool shouldShowDebugButton;
  BuildContext context;

  KSFloatingDebugButton({
    super.key,
    this.shouldShowDebugButton = false,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return FloatBubble(
      show: shouldShowDebugButton,
      initialAlignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          navigatorState.pushNamed(ScreenName.debug);
        },
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.3),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 2),
                    color: Colors.blue.withOpacity(0.5),
                    blurRadius: 5,
                  )
                ]),
            child: const FittedBox(
              child: KSText(
                'Debug',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KSBaseWidget extends StatelessWidget {
  final Stream<bool>? loading;
  final AppBar? appBar;
  final Drawer? drawer;
  final Widget? child;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  final bool safeAreaLeft;

  final bool safeAreaRight;

  final bool safeAreaTop;

  final bool safeAreaBottom;

  final GlobalKey<ScaffoldState>? scaffoldKey;

  const KSBaseWidget({
    super.key,
    this.loading,
    this.appBar,
    this.drawer,
    this.child,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.safeAreaLeft = true,
    this.safeAreaRight = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      backgroundColor: backgroundColor ?? AppStyle.primaryColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawer: drawer,
      body: SafeArea(
        top: !extendBodyBehindAppBar && safeAreaTop,
        bottom: safeAreaBottom,
        left: safeAreaLeft,
        right: safeAreaRight,
        child: StreamBuilder<bool>(
          stream: loading,
          builder: (context, snapshot) {
            return Stack(
              children: [
                child ?? const SizedBox.shrink(),
                if (snapshot.data ?? false)
                  Container(
                    decoration:
                    BoxDecoration(color: Colors.grey.withOpacity(0.1)),
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}

class CustomTag extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final EdgeInsets margin;

  const CustomTag({
    Key? key,
    required this.text,
    this.backgroundColor = Colors.green,
    this.margin = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: KSText(text,
          style: KSTheme
              .of(context)
              .style
              .ts12w700
              .copyWith(color: AppStyle.whiteBg)),
    );
  }
}

class CustomTag2 extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final EdgeInsets margin;

  const CustomTag2({
    Key? key,
    required this.text,
    this.backgroundColor = Colors.green,
    this.margin = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppStyle.primaryColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
      ),
      child: KSText(
        text,
        style: KSTheme
            .of(context)
            .style
            .ts12w700
            .copyWith(color: AppStyle.whiteBg),
      ),
    );
  }
}

Future<dynamic> showAlert(BuildContext context, String title, String message,
    {List<CupertinoButton>? actions,
      List<ElevatedButton>? actionAndroids}) async {
  return showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
          title: KSText(title),
          content: KSText(message),
          actions: [
            if (actionAndroids != null)
              ...actionAndroids
            else
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const KSText('Đồng ý'))
          ],
        ),
  );
}

Future<void> showAlertIOS(BuildContext _context, String title, String message,
    {bool? autoPop,
      bool? autoBackPop,
      void Function()? onTap,
      bool? oneButton}) async {
  final _context = navigatorKey.currentContext;
  if (_context == null) return;

  await showCupertinoDialog(
      context: _context!,
      builder: (context) =>
          CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (oneButton == null)
                CupertinoButton(
                    child: Text(onTap != null ? "Không" : "Đồng ý"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              if (onTap != null)
                CupertinoButton(
                    child: const Text('Có'),
                    onPressed: () {
                      if (autoPop == true) {
                        Navigator.pop(context);
                      }
                      onTap();
                      if (autoBackPop == null) {
                        Navigator.pop(context);
                      }
                    })
            ],
          ));

  // if (onTap != null) {
  //   onTap();
  // }
}

class ArrowContainer extends StatelessWidget {
  final String name;

  const ArrowContainer({super.key, this.name = ""});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            // Height of the container
            decoration: BoxDecoration(
              color: Colors.white, // Container background color
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            child: Column(
              children: [
                // Your container content goes here (optional)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: KSText(
                      overflow: TextOverflow.ellipsis,
                      name,
                      style: TextStyle(
                          color: AppStyle.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                // The arrow shape at the bottom center
              ],
            ),
          ),
          CustomPaint(
            size: const Size(20, 7), // Size of the arrow
            painter: InvertedTrianglePainter(),
          ),
        ],
      ),
    );
  }
}

class InvertedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white // Color of the arrow
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(size.width / 2, size.height) // Starting point (bottom center)
      ..lineTo(0, 0) // Top left corner of the inverted triangle
      ..lineTo(size.width, 0) // Top right corner of the inverted triangle
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class TopBorderContainer extends StatelessWidget {
  final Widget child; // Widget được truyền vào

  const TopBorderContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppStyle.primaryGrayBroder,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child, // Hiển thị widget được truyền vào
          ],
        ),
      ),
    );
  }
}

// void showCustomLoading({bool moveRoute = false}) {
//   BotToast.showCustomLoading(
//     toastBuilder: (_) => Container(
//       width: 100.w,
//       height: 100.h,
//       color: AppStyle.whiteBg.withOpacity(moveRoute ? 1 : 0.2),
//       child: Center(
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(25),
//           child: Container(
//             color: Colors.white.withOpacity(0.9),
//             height: 140,
//             width: 140,
//             child: KSLoadingDot(),
//           ),
//         ),
//       ),
//     ),
//   );
// }

void showCustomLoading({bool moveRoute = false}) {
  BotToast.showCustomLoading(
    toastBuilder: (_) =>
        Container(
            width: 100.w,
            height: 100.h,
            color: AppStyle.whiteBg.withOpacity(moveRoute ? 1 : 0.2),
            child: LoadingLottie()),
  );
}

Future<void> closeCustomLoading() async {
  await Future.delayed(Duration(milliseconds: 3000));
  BotToast.closeAllLoading();
}

Future<void> navigateWithLoading(
    Future<void> Function() navigationAction) async {
  navigationAction();
  await loadDataWithLoading(
      action: () async {
        // Thực hiện hành động điều hướng
      },
      moveRoute: true);
}

Future<void> loadDataWithLoading({Future<void> Function()? action,
  int milliseconds = 1000,
  bool moveRoute = false}) async {
  showCustomLoading(moveRoute: moveRoute);

  await Future.delayed(Duration(milliseconds: milliseconds));

  if (action != null) {
    await action(); // Chờ action hoàn tất
  }

  await closeCustomLoading(); // Cuối cùng, đóng loading
}

@immutable
class KSSizedBox extends StatelessWidget {
  double? heightPercent;
  double? widthPercent;
  final Widget? child;

  KSSizedBox({super.key, this.heightPercent, this.widthPercent, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthPercent?.w ?? 0,
      height: heightPercent?.h ?? 0,
      child: child,
    );
  }
}

@immutable
class KSText extends StatelessWidget {
  final String title;
  final double minSizeText;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const KSText(this.title, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.minSizeText = 8,
    this.selectionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      // minFontSize: minSizeText,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }
}

class AttachmentGallery extends StatefulWidget {
  final List<String> imagePaths;
  final ValueChanged<int> onImageTap;

  const AttachmentGallery({
    Key? key,
    required this.imagePaths,
    required this.onImageTap,
  }) : super(key: key);

  @override
  State<AttachmentGallery> createState() => _AttachmentGalleryState();
}

class _AttachmentGalleryState extends State<AttachmentGallery> {
  bool isExpanded = false;
  final maxVisibleImages = 2;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: isExpanded
          ? widget.imagePaths.length + 1
          : (widget.imagePaths.length > maxVisibleImages
          ? maxVisibleImages + 1
          : widget.imagePaths.length),
      itemBuilder: (context, index) {
        if (!isExpanded &&
            index == maxVisibleImages &&
            widget.imagePaths.length > maxVisibleImages) {
          return _buildExpandButton();
        }

        if (isExpanded && index == widget.imagePaths.length) {
          return _buildCollapseButton();
        }

        return _buildImage(widget.imagePaths[index], index);
      },
    );
  }

  Widget _buildExpandButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.blue, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          "+${widget.imagePaths.length - maxVisibleImages}",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCollapseButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.red, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Icon(Icons.close, color: Colors.red, size: 40),
      ),
    );
  }

  Widget _buildImage(String url, int index) {
    return FutureBuilder<void>(
      future: Future.delayed(Duration(milliseconds: 500)), // Delay từng ảnh
      builder: (context, snapshot) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.3,
          child: GestureDetector(
            onTap: () {
              widget.onImageTap(index); // Gửi index về callback khi bấm vào ảnh
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                url,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child:
                    Icon(Icons.broken_image, color: Colors.red, size: 40),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class KSProgressbar extends StatelessWidget {
  // double width;
  double? height;
  double progress;
  Duration duration;
  BorderRadius? borderRadius;
  Color backgroundColor;
  Color foregroundColor;
  Color fontColor;

  KSProgressbar({super.key,
    // required this.width,
    this.height = 10,
    this.duration = const Duration(milliseconds: 275),
    this.backgroundColor = const Color.fromARGB(255, 205, 205, 205),
    this.foregroundColor = Colors.amberAccent,
    this.fontColor = Colors.black,
    this.borderRadius,
    required this.progress});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(16)),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: height,
      ),
      TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: progress),
        duration: duration,
        builder: (context, value, child) {
          return AnimatedSize(
            duration: duration,
            child: Container(
              decoration: BoxDecoration(
                  color: foregroundColor,
                  borderRadius: borderRadius ?? BorderRadius.circular(16)),
              width: MediaQuery
                  .of(context)
                  .size
                  .width * (value / 100),
              height: height,
            ),
          );
        },
      )
    ]);
  }
}

class KSPrint {
  static void log(String message) {
    if (kDebugMode) {
      print("📝 $message");
    }
  }
}

void showImagePopupAll(BuildContext context, String url) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Nền trong suốt
        child: Stack(
          children: [
            // Ảnh hiển thị
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: KSText(
                      "Failed to load image",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
            // Nút X ở góc trên bên trái
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Đóng popup
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showCustomDialog({
  required BuildContext context,
  required String info,
  required String title,
  String? successMessage,
  String? detail,
  String? errorsMessage,
  String? dangerMessage,
  VoidCallback? onContinue,
  VoidCallback? onHome,
  VoidCallback? onOff,
  bool isShowButton = true,
  bool isShowOnlyActionButton = false,
  bool isShowClose = true,
}) {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  showDialog<void>(
    context: context,
    barrierDismissible: false, // Người dùng phải nhấn nút để đóng
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Bo góc hộp thoại
            ),
            contentPadding: EdgeInsets.zero,
            // Xóa padding mặc định
            content: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    // Giao diện gọn gàng
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: KSTheme
                            .of(context)
                            .style
                            .ts35w500,
                      ),
                      if (detail != null)
                        Text(
                          maxLines: 2,
                          detail,
                          textAlign: TextAlign.center,
                          style: KSTextStyle()
                              .style(
                            15,
                            FontWeight.w400,
                            fontBuilder: GoogleFonts.cormorantInfant,
                          )
                              .copyWith(color: AppStyle.primaryGreen647B58),
                        ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],   // màu nền khung
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon copy


                            // Text nội dung
                            Expanded(
                              child: Text(
                                info,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: info));
                                // Optional: show toast/snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Copy')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                      MessengerButton(
                          context: context,
                          username: "0903383236",
                          message: () {
                            return info;
                          }),
                      if (successMessage != null)
                        Text(
                          successMessage.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      if (errorsMessage != null)
                        Text(
                          errorsMessage.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      if (dangerMessage != null)
                        Text(
                          dangerMessage.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),

                    ],
                  ),
                ),
                if (isShowClose)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        if (onOff != null) {
                          onOff(); // Gọi hàm
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // Màu nền mờ
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close,
                            color: Colors.black, size: 15), // Dấu "X"
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class KSHoverContainer extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color normalColor;
  final Color hoverColor;

  const KSHoverContainer({
    super.key,
    required this.child,
    this.width = 150,
    this.height = 150,
    this.borderRadius,
    this.normalColor = Colors.blue,
    this.hoverColor = Colors.blueAccent,
  });

  @override
  State<KSHoverContainer> createState() => _KSHoverContainerState();
}

class _KSHoverContainerState extends State<KSHoverContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: widget.width,
        height: widget.height,
        // transform: _isHovered
        //     ? Matrix4.identity()..scale(1.05)
        //     : Matrix4.identity()..scale(1.0),
        decoration: BoxDecoration(
          color: _isHovered ? widget.hoverColor : widget.normalColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
          boxShadow: _isHovered
              ? [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}

class HoverText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Color hoverColor;
  final Color normalColor;
  final VoidCallback? onTap;

  const HoverText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.left,
    required this.hoverColor,
    required this.normalColor,
    this.onTap,
  });

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: widget.style.copyWith(
            color: _isHovered ? widget.hoverColor : widget.normalColor,
          ),
          child: KSText(
            widget.text,
            textAlign: widget.textAlign,
          ),
        ),
      ),
    );
  }
}

