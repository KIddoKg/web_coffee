import 'package:xanh_coffee/screens/home_mobile/home_mobile_screen.dart';

import '../share/app_imports.dart';
import 'empty/emptyPage.dart';
import 'home/home_screen.dart';
// import 'home_mobile/home_mobile_screen.dart';
//
class HomeScreenAdaptive extends StatelessWidget {
  const HomeScreenAdaptive({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;

        if (width <= 190) {
          // Quá nhỏ (co hẹp hoặc chưa load layout)
          return   EmptyPage();
        } else if (width < 700) {
          // Mobile
          return const HomeMobileScreen();
        } else {
          // Desktop
          return const HomeScreen();
        }
      },
    );
  }
}
