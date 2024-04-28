import 'package:flutter/material.dart';
import 'package:mal/model/note_model.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/text_styles.dart';

class NoteItem extends StatelessWidget {
  const NoteItem(this.noteModel, this.callback, {Key? key}) : super(key: key);
  final NoteModel noteModel;
  final Function(int) callback;//0 delete 1 edit
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        shape: BoxShape.rectangle,
        color: kGray,
      ),
      margin: const EdgeInsetsDirectional.only(top: 16, start: 16, end: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsetsDirectional.only(top: 16, start: 16, bottom: 16, end: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    noteModel.title??"",
                    style: languageStyle,
                  ),
                  const SizedBox(height: 4,),
                  Text(
                    noteModel.content??"",
                    style: subLabel2Style,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(end: 8),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    callback(0);
                  },
                  child: const Icon(
                    Icons.delete,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 6,),
                InkWell(
                  onTap: () {
                    callback(1);
                  },
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
