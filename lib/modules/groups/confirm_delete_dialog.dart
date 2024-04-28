import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/styles/text_styles.dart';
import '../../translations/locale_keys.g.dart';

class ConfirmDeleteDialog extends StatefulWidget {
  const ConfirmDeleteDialog(this.length, {Key? key}) : super(key: key);
  final int? length;
  @override
  State<ConfirmDeleteDialog> createState() => _ConfirmDeleteDialogState();
}

class _ConfirmDeleteDialogState extends State<ConfirmDeleteDialog> {
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
              LocaleKeys.delete.tr(args: [widget.length?.toString()??""]),
              style: headingStyle,
            ),

          ),
          const SizedBox(height: 16,),
          Container(
            height: 58.h,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              LocaleKeys.confirm_delete.tr(),
              style: titleBlackStyle,
            ),
          )
        ],
      ),
    );
  }
}
