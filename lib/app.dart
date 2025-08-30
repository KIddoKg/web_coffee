import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:xanh_coffee/router/router_app.dart';
import 'package:xanh_coffee/router/router_string.dart';
import 'package:xanh_coffee/share/share_widget.dart';
import 'package:xanh_coffee/share/size_configs.dart';
import 'package:xanh_coffee/theme/ks_theme.dart';
import 'package:xanh_coffee/helper/widget/widget_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';


import 'generated/l10n.dart';
import 'helper/di/di.dart';


class MyApp extends StatefulWidget {
  final bool shouldShowDebugButton;

  const MyApp({
    required this.shouldShowDebugButton,
    super.key,
  });

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.updateLocale(newLocale);
  }


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends BaseState<MyApp> with WidgetsBindingObserver {
  // final NotificationUtil notificationUtil = di();
  // @override
  // final FCMUtil fcmUtil = di();
  // NotificationServicesFireBase _notificationServicesFireBase = NotificationServicesFireBase();
  Locale _locale = const Locale('vi');

  void updateLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // if (!kDebugMode) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    // }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('App Lifecycle State:  $state');
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      widgetUtil.closeGlobalKeyboard();
    }

    if (state == AppLifecycleState.paused) {
      widgetUtil.closeGlobalKeyboard();
    }
    if (state == AppLifecycleState.resumed) {}
  }
  //
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return OverlaySupport.global(
      child: KSTheme(
        child:Sizer(
          builder: (context, orientation, screenType) {
          return MaterialApp(

          // Cần có dòng này
          navigatorObservers: [BotToastNavigatorObserver()],
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          builder: (context, child) {
            return  BotToastInit()(
              context,
              MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1, // Ngăn không cho phóng đại văn bản
                ),
                child: Stack(
                  children: [
                    child ?? const SizedBox.shrink(),
                    if (widget.shouldShowDebugButton)
                      KSFloatingDebugButton(
                        context: context,
                        shouldShowDebugButton: widget.shouldShowDebugButton,
                      ),
                  ],
                ),
              ),
            );
          },

          // navigatorObservers: [ChuckerFlutter.navigatorObserver],
          // navigatorObservers: [BotToastNavigatorObserver()],
          initialRoute: ScreenName.root,
          onGenerateRoute: di<AppRoute>().generateRoute,
          localizationsDelegates: _localizationDelegates(),
          supportedLocales: _supportedLocales(),
                            );
        }
                        ),
      ),
    );
  }

// Hàm tiện ích để cung cấp `localizationsDelegates`
  List<LocalizationsDelegate> _localizationDelegates() {
    return const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      S.delegate, // Đảm bảo delegate localization được khai báo
    ];
  }

// Hàm tiện ích để cung cấp `supportedLocales`
  List<Locale> _supportedLocales() {
    return const [
      Locale('vi', ''), // Hỗ trợ tiếng Việt
      Locale('en', ''), // Hỗ trợ tiếng Anh
    ];
  }


// @override
  // Widget build(BuildContext context) {
  //   SizeConfig().init(context);
  //   return GestureDetector(
  //     // onTap: () => AppUtils.dismissKeyboard(),
  //     child: GetMaterialApp(
  //       navigatorObservers: [ChuckerFlutter.navigatorObserver],
  //       localizationsDelegates: const [
  //         GlobalMaterialLocalizations.delegate,
  //         GlobalWidgetsLocalizations.delegate,
  //         GlobalCupertinoLocalizations.delegate,
  //       ],
  //       supportedLocales: const [
  //                     Locale('vi', ''), // Add supported locales
  //                     Locale('en', ''), // Example: add more locales if needed
  //                   ],
  //       theme: ThemeData(
  //         // fontFamily:FontFamily.baiJamjuree,
  //         primaryColor: AppStyle.primaryColor,
  //         // scaffoldBackgroundColor: AppColors.whiteBGColor,
  //       ),
  //       debugShowCheckedModeBanner: false,
  //       enableLog: true,
  //       initialRoute: ScreenName.root,
  //       getPages: ScreenName.AppRoute,
  //       // getPages: AppPages.routes,
  //       builder: (context, child) => Stack(
  //         children: [
  //           child ?? const SizedBox.shrink(),
  //           FloatingDebugButton(
  //             shouldShowDebugButton: widget.shouldShowDebugButton,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
