
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:injectable/injectable.dart';
import 'package:xanh_coffee/screens/empty/emptyPage.dart';
import 'package:xanh_coffee/screens/home/home_screen.dart';
import 'package:xanh_coffee/share/app_imports.dart';

import '../screens/home_move.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final NavigatorState navigatorState = navigatorKey.currentState!;

@LazySingleton()
class AppRoute {
  PageRoute generateRoute(RouteSettings settings) {
    final name = settings.name;
    final args = settings.arguments;

    switch (name) {
      case ScreenName.root:
        if (args is Map<String, dynamic>) {
          Map<String, dynamic>? payload = args['payload']; // Get 'id' from the map

          return _materialPage(

              HomeScreenAdaptive(

              ),
              settings);
        }

        return _materialPage(
            HomeScreenAdaptive(

            ),
            settings);
    }

    return _materialPage(const EmptyPage(), settings);
  }

  MaterialPageRoute _materialPage(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => page, settings: settings);
  }

// PageRoute _noAnimationRoute(Widget page, RouteSettings settings) {
//   return CustomPageRouteBuilder(
//       pageBuilder: (BuildContext context, Animation<double> animation,
//               Animation<double> secondaryAnimation) =>
//           page,
//       transitionDuration: Duration.zero,
//       reverseTransitionDuration: Duration.zero);
// }
}
