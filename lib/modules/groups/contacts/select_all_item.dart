import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mal/translations/locale_keys.g.dart';

import 'contact_data.dart';

class SelectAllItem extends StatefulWidget {
  const SelectAllItem(this.data,this.callback,{Key? key}) : super(key: key);
  final Function(bool) callback;
  final ContactData data;

  @override
  State<SelectAllItem> createState() => _SelectAllItemState();
}

class _SelectAllItemState extends State<SelectAllItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:widget.data.isSelected? Colors.grey[300]!:Colors.white,
      child:  ListTile(
          selected: widget.data.isSelected,
          leading: Icon(widget.data.isSelected?Icons.check_circle:Icons.check_circle_outline),
          title: Text(LocaleKeys.select_all.tr()),
          onTap: toggleSelection // what should I put here,
      ),
    );
  }
  void toggleSelection() {
    setState(() {
      widget.data.isSelected = !widget.data.isSelected;
    });
    widget.callback(widget.data.isSelected);
  }
}
