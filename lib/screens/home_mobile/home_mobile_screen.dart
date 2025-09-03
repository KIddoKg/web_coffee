import 'dart:developer';

import 'dart:ui';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:web_smooth_scroll/web_smooth_scroll.dart';
import 'package:xanh_coffee/helper/format/helper.dart';

import 'package:xanh_coffee/screens/home_mobile/viewModel/home_mobile_screen_vm.dart';
import 'package:xanh_coffee/share/share_on_app.dart';
import 'package:xanh_coffee/share/size_configs.dart';

import '../../generated/fonts.gen.dart';
import '../../generated/l10n.dart';
import '../../share/app_imports.dart';
import '../../share/text_style.dart';
import 'package:lottie/lottie.dart';

import '../home/model/product_model.dart';



part './widgets/header_widget.dart';
part './widgets/confirm_widget.dart';
part './widgets/footer_widget.dart';
part './widgets/about_widget.dart';
part './widgets/all_product_widget.dart';
part './widgets/ads_widget.dart';
part './widgets/feedback_widget.dart';
part './widgets/app_food_widget.dart';

class HomeMobileScreen extends StatefulWidget {
  const HomeMobileScreen({super.key});

  @override
  State<HomeMobileScreen> createState() => _HomeMobileScreenState();
}

class _HomeMobileScreenState extends State<HomeMobileScreen> {
  @override
  Widget build(BuildContext context) {
    final HomeMobileScreenVm _vm = di<HomeMobileScreenVm>();
    // _vm.init(context);
    return ChangeNotifierProvider.value(
      value: _vm, // Provide the same instance from DI to the widget tree
      child: HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  // late Function(GlobalKey) runAddToCartAnimation;
  late final ScrollController _scrollController;
  @override
  void initState() {

    _scrollController = ScrollController();
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {


      // Lắng nghe scroll
      _scrollController.addListener(() {
        
        // Gọi hàm ViewModel khi scroll

      });
      final vm = Provider.of<HomeMobileScreenVm>(context, listen: false);

      vm.init( );
      vm.loadSavedLocale(context);

    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeMobileScreenVm>(
      builder: (context, vm, child) {
        return AddToCartAnimation(
          // To send the library the location of the Cart icon
          cartKey: vm.cartKey,
          height: 30,
          width: 30,
          opacity: 0.85,
          dragAnimation: const DragToCartAnimationOptions(
            rotation: true,
          ),
          jumpAnimation: const JumpAnimationOptions(),
          createAddToCartAnimation: (addToCartAnimationMethod) {
            vm.runAddToCartAnimation = addToCartAnimationMethod;
          },
          child: KSScaffold(
            backgroundColor: AppStyle.whiteYellow,
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: WebSmoothScroll(
              controller:_scrollController,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [

                  const SliverToBoxAdapter(child: _HeaderWidget()),
                  const SliverToBoxAdapter(child: _AllProductWidget()),
                  const SliverToBoxAdapter(child: _AppFoodWidget()),
                  const SliverToBoxAdapter(child: _AdsWidget()),
                  const SliverToBoxAdapter(child: _FeedbackWidget()),

                  const SliverToBoxAdapter(child: _ConfirmWidget()),
                  const SliverToBoxAdapter(child: _FooterWidget()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}


