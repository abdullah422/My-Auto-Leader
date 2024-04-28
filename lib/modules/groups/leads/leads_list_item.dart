import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/modules/groups/leads/lead_data.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/text_styles.dart';

class LeadsListItem extends StatefulWidget {
  const LeadsListItem(this.leadData, this.callback, {Key? key}) : super(key: key);
  final LeadData leadData;
  final Function() callback;

  @override
  State<LeadsListItem> createState() => _LeadsListItemState();
}

class _LeadsListItemState extends State<LeadsListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kGray,
          borderRadius: BorderRadius.circular(8)
      ),
      margin: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
      padding: const EdgeInsetsDirectional.all(16),
      child: Row(
        children: [
          Container(
            width: 72.h,
            height: 72.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle
            ),
            child: Text(
              widget.leadData.imageName??"",
              style: titleBlackStyle,
            ),
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    widget.leadData.name??"",
                    style: titleBlackStyle
                ),
                const SizedBox(height: 8,),
                Text(
                    widget.leadData.number??"",
                    style: GoogleFonts.almarai( textStyle:const TextStyle(
                        fontSize: 14
                    ),)
                )
              ],
            ),
          ),
          const SizedBox(width: 16,),
          IconButton(
            onPressed: () {
              if(widget.leadData.isEditShown){
                widget.leadData.isSelected = !widget.leadData.isSelected;
                setState(() {

                });
                widget.callback();
              }
            },
            icon: Icon(
              widget.leadData.isEditShown
                  ? widget.leadData.isSelected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank
                  : Icons.arrow_forward_ios_outlined,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

