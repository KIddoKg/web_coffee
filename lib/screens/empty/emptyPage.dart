
import 'package:flutter/material.dart';
import 'package:xanh_coffee/share/app_imports.dart';

import '../../generated/l10n.dart';
import '../../share/share_widget.dart';
import '../../theme/ks_theme.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        child: Container(
          color: AppStyle.whiteYellow,
          child: Center(
              child:    KSText(
            "Xanh Coffee",
            style: KSTheme.of(context)
                .style
                .ts12w700
                .copyWith(color: AppStyle.primaryGreen_0_81_49),
          )),
        ),
      );
}
