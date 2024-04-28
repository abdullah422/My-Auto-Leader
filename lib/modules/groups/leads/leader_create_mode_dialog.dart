import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mal/modules/groups/contacts/contact_data.dart';
import 'package:mal/shared/components/app_routes.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../translations/locale_keys.g.dart';

class LeaderCreateModeDialog extends StatefulWidget {
  const LeaderCreateModeDialog(this.groupId, this.callback, {Key? key}) : super(key: key);
  final Function() callback;
  final int groupId;
  @override
  State<LeaderCreateModeDialog> createState() => _LeaderCreateModeDialogState();
}

class _LeaderCreateModeDialogState extends State<LeaderCreateModeDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.creating_mode.tr(),
            style: languageStyle,
          ),
          const SizedBox(height: 8,),
          ListView(
            shrinkWrap: true,
              children: [
                InkWell(
                  onTap: ()async{
                    await Navigator.of(context).pushNamed(AppRoutes.editLeader,
                    arguments: {"group_id": widget.groupId});
                    widget.callback();
                  },
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(4),
                    child: Text(
                      LocaleKeys.manual.tr(),
                      style: normalGrayStyle,
                    ),
                  ),
                ),
                const SizedBox(height: 4,),

                InkWell(
                  onTap: ()async{
                    if (await Permission.contacts.request().isGranted) {
                      await Navigator.of(context).pushNamed(AppRoutes.selectContacts,
                        arguments: widget.groupId
                      );
                      widget.callback();
                    }

                  },
                  child: Container(
                    padding: const EdgeInsetsDirectional.all(4),
                    child: Text(
                      LocaleKeys.load_from_contact.tr(),
                      style: normalGrayStyle,
                    ),
                  ),
                ),
              ],
          )
        ],
      ),
    );
  }
}
