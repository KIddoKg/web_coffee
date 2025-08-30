part of '../home_mobile_screen.dart';

class _ConfirmWidget extends StatefulWidget {
  const _ConfirmWidget({super.key});

  @override
  State<_ConfirmWidget> createState() => _ConfirmWidgetState();
}

class _ConfirmWidgetState extends State<_ConfirmWidget> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final width = SizeConfig.screenWidth!;
    final height = SizeConfig.screenHeight!;

    return Consumer<HomeMobileScreenVm>(builder: (context, vm, child) {
      return Column(
        children: [

        ],
      );
    });
  }
}
