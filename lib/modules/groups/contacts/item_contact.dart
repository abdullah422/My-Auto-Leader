
import 'package:flutter/material.dart';

import '../../../shared/styles/text_styles.dart';
import 'contact_data.dart';

class ItemContact extends StatefulWidget {
  const ItemContact(this.data, {Key? key}) : super(key: key);
  final ContactData data;
  @override
  State<ItemContact> createState() => _ItemContactState();
}

class _ItemContactState extends State<ItemContact> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color:widget.data.isSelected? Colors.grey[300]!:Colors.white,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
        ListTile(
            selected: widget.data.isSelected,
            leading: Icon(widget.data.isSelected?Icons.check_circle:Icons.check_circle_outline),
            title: Text(widget.data.contact?.displayName??"",
            style: titleForActionFieldStyle,),
            subtitle: Text(widget.data.contact?.phones?.isNotEmpty==true?widget.data.contact?.phones![0].value??"":""),
            onTap: toggleSelection // what should I put here,
        )
      ]),
    );
  }

  void toggleSelection() {
    setState(() {
        widget.data.isSelected = !widget.data.isSelected;
    });
  }
}
