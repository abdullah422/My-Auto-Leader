import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/modules/groups/group_data.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../shared/styles/text_styles.dart';

class GroupItem extends StatefulWidget {
  const GroupItem(this.data, this.callback, {Key? key}) : super(key: key);
  final GroupData data;
  final Function() callback;
  @override
  State<GroupItem> createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
      BoxDecoration(color: kGray, borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
      padding: const EdgeInsetsDirectional.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.data.name ?? "", style: titleBlackStyle),
                const SizedBox(
                  height: 8,
                ),
                Text("${LocaleKeys.leads.tr()} ${widget.data.leadersCount ?? 0}",
                    style: GoogleFonts.almarai(
                      textStyle: const TextStyle(fontSize: 12),
                    ))
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          IconButton(
            onPressed: () {
              if(widget.data.isEditShown){
                widget.data.isSelected = !widget.data.isSelected;
                setState(() {

                });
                widget.callback();
              }
            },
            icon: Icon(
              widget.data.isEditShown
                  ? widget.data.isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank
                  : Icons.arrow_forward_ios_outlined,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}


