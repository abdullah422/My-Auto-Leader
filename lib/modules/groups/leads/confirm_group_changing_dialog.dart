import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/styles/text_styles.dart';
import '../../../translations/locale_keys.g.dart';

class ConfirmGroupChangingDialog extends StatefulWidget {
  const ConfirmGroupChangingDialog(this.groupName, {Key? key}) : super(key: key);
  final String groupName;
  @override
  State<ConfirmGroupChangingDialog> createState() => _ConfirmGroupChangingDialogState();
}

class _ConfirmGroupChangingDialogState extends State<ConfirmGroupChangingDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: AlignmentDirectional.center,
            child: Text(
              LocaleKeys.confirm.tr(),
              style: headingStyle,
            ),

          ),
          const SizedBox(height: 16,),
          Container(
            height: 58.h,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              LocaleKeys.sure_to_change_group.tr(args: [widget.groupName]),
              style: titleBlackStyle,
            ),
          )
        ],
      ),
    );
  }
}
