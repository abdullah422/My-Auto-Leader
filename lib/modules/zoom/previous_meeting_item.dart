import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../model/meet_model.dart';

class PreviousMeetingItem extends StatefulWidget {
  const PreviousMeetingItem(this.meetModel,{Key? key}) : super(key: key);
  final MeetModel meetModel;

  @override
  State<PreviousMeetingItem> createState() => _PreviousMeetingItemState();
}

class _PreviousMeetingItemState extends State<PreviousMeetingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 16),
      padding: const EdgeInsetsDirectional.only(
          start: 16, top: 16, bottom: 16, end: 16),
      decoration: const BoxDecoration(
        color: Color(0xffe6e6e6),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/meeting.svg',
            width: 24,
            height: 24,
          ),
          Container(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text(
                widget.meetModel.topic??"",
                style: GoogleFonts.almarai(textStyle:const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              )),
              const SizedBox(
                height: 4,
              ),
              Text(
                convertToLocalDate(widget.meetModel.startTime),
                style: GoogleFonts.almarai(textStyle:const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          ),
          Expanded(child: Container()),
          Container(
            margin: const EdgeInsetsDirectional.only(end: 0),
            padding: const EdgeInsetsDirectional.only(
                start: 8, end: 8, top: 4, bottom: 4),
            decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Text(
              LocaleKeys.done.tr(),
              style: GoogleFonts.almarai(textStyle:const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),)
            ),
          )
        ],
      ),
    );
  }

  String convertToLocalDate(String? startTime) {
    if (startTime != null) {
      DateTime d = DateFormat("yyyy-MM-dd HH:mm:ss", "en").parse(startTime, true);
      d = d.toLocal();
      return DateFormat("yyyy/MM/dd HH:mm", "en").format(d);
    }
    return "";
  }
}



