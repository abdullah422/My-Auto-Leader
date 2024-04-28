import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/model/task_model.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/text_styles.dart';

class TaskItem extends StatefulWidget {
  const TaskItem(this.taskModel, this.callback, {Key? key}) : super(key: key);
  final TaskModel taskModel;
  final Function(int) callback;//0 delete 1 edit 2 complete/incomplete
  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
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
          Container(
            margin: const EdgeInsetsDirectional.only(start: 8),
            child: InkWell(
              onTap: () {
                widget.callback(2);
              },
              child: Icon(
                widget.taskModel.status == "complete"?
                Icons.check_box:
                Icons.check_box_outline_blank,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsetsDirectional.only(top: 16, start: 16, bottom: 16, end: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.taskModel.title??"",
                    style: GoogleFonts.almarai(
                        fontSize: 24.sp, fontWeight: FontWeight.bold, color: kBlack,
                        decoration: widget.taskModel.status == "complete"?
                        TextDecoration.lineThrough:TextDecoration.none
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(end: 8,top: 16, bottom: 16),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    widget.callback(1);
                  },
                  child: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8,),
                InkWell(
                  onTap: () {
                    widget.callback(0);
                  },
                  child: const Icon(
                    Icons.delete,
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
