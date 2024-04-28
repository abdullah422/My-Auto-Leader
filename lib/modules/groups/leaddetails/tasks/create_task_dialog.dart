import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/styles/colors.dart';
import '../../../../shared/styles/text_styles.dart';
import '../../../../translations/locale_keys.g.dart';

class CreateTaskDialog extends StatelessWidget {
  const CreateTaskDialog(this.isEdit, this.titleController, {Key? key}) : super(key: key);
  final TextEditingController titleController;
  final bool isEdit;
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
              isEdit?LocaleKeys.edit.tr():LocaleKeys.new_task.tr(),
              style: headingStyle,
            ),

          ),
          const SizedBox(height: 16,),
          Container(
            height: 58.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: kGray,
                borderRadius: BorderRadius.circular(8)
            ),
            alignment: AlignmentDirectional.centerStart,
            child: TextFormField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                hintText: LocaleKeys.task_name.tr(),
                hintStyle: bigHintForTextFieldStyle,
                focusedErrorBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.sp)),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(4.sp)),
                  borderSide: BorderSide(color: kGray, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(4.sp)),
                  borderSide: BorderSide(color: kGray, width: 2),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width:2),
                ),
                errorStyle:errorValidationStyle,
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: kBorder, width: 2),
                ),
                filled: true,
                fillColor: kGray,
                isDense: true,
                contentPadding: EdgeInsetsDirectional.only(start: 8.w,top: 8.h, bottom: 8.h, end: 8.w),
              ),
              cursorColor: Colors.black,
              maxLines: 1,
              validator: (value) {
                if (value!.isEmpty) {
                  return LocaleKeys.required_field.tr();
                }
                return null;
              },
              controller: titleController,

              style:TextStyle(fontSize: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}



