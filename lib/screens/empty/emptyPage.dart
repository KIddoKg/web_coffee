
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../share/share_widget.dart';
import '../../theme/ks_theme.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        child: Container(
          color: KSTheme.of(context).color.systemGreen,
          child: Center(
              child:    KSText(
            "S.current.content_does_not_exist",
            style: KSTheme.of(context)
                .style
                .ts12w400
                .copyWith(color: Colors.white),
          )),
        ),
      );
}
