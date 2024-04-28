import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/text_styles.dart';

class AddItem extends StatelessWidget {
  const AddItem(this.text, this.callback, {Key? key}) : super(key: key);
  final String text;
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle,
          color: kGray,
        ),
        margin: const EdgeInsetsDirectional.only(top: 16, start: 16, end: 16),
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        alignment: AlignmentDirectional.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add),
            Text(text,style: GoogleFonts.almarai(fontSize: 16, color: kBlack),)
          ],
        ),
      ),
    );
  }
}
