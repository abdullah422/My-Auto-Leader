import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../../model/stage_details_model.dart';

/*
class BuildQuestionItem extends StatelessWidget {
  final cubit;
  final Question question;
  final int index;

  const BuildQuestionItem(
      {Key? key, required this.question, required this.index, this.cubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:index==1?0:16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.sp),
        color: const Color(0xFFE5E5E5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
                left: 14.w, right: 19.w, top: 8.h, bottom: 10.h),
            child: Text(
              LocaleKeys.question.tr() + '  ${index.toString()}',
              style: questionNumberStyle,
            ),
          ),
           Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 5.h),
              width: 364.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.sp),
                  ),),
              child: Text(
                question.question.toString(),
                style: questionBodyStyle,
              ),
            ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: question.answers!.map((answer) {
                  return InkWell(
                    onTap: () {
                      cubit.addToAnswerList(qId: question.id, aId: answer.id);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5.h),
                      child: Row(
                        children: [
                          Container(
                            width: 15.sp,
                            height: 15.sp,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: cubit.answersMap[question.id] ==
                                        answer.id
                                        ? kBlack
                                        : kBlack,
                                    width: 2),
                                color:
                                cubit.answersMap[question.id] == answer.id
                                    ? kYellow
                                    : null),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            answer.answer.toString(),
                            style: answerStyle,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList()),
          ),
        ],
      ),
    );
  }
}*/
class BuildQuestionItem extends StatelessWidget {
  final cubit;
  final Question question;
  final int index;

  const BuildQuestionItem({
    Key? key,
    this.cubit,
    required this.question,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.w),
                        topRight: Radius.circular(15.w)),
                    //border: Border(top:BorderSide(color:kBlack),left:BorderSide(color:kBlack,style: BorderStyle.solid),right: BorderSide(color:kBlack),),
                    boxShadow: [
                      BoxShadow(
                          color: kBlack,
                          offset: const Offset(1, -1),
                          spreadRadius: 0,
                          blurRadius: 0),
                      BoxShadow(
                          color: kBlack,
                          offset: Offset(-1, -1),
                          spreadRadius: 0,
                          blurRadius: 0)
                    ],
                    color: kYellow),
                child: Center(
                  child: Text(
                    LocaleKeys.question.tr() + '  ${index.toString()}',
                    style: GoogleFonts.almarai(
                        fontSize: 18.sp,
                        color: kBlack,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.sp),
                border: Border.all(color: Colors.black)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Row(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.w),
                              bottomRight: Radius.circular(15.w)),
                          //border: Border(top:BorderSide(color:kBlack),left:BorderSide(color:kBlack,style: BorderStyle.solid),right: BorderSide(color:kBlack),),
                          boxShadow: [
                            BoxShadow(
                                color: kBlack,
                                offset: const Offset(1, 1),
                                spreadRadius: 0,
                                blurRadius: 0),
                            BoxShadow(
                                color: kBlack,
                                offset: Offset(-1, -1),
                                spreadRadius: 0,
                                blurRadius: 0)
                          ],
                          color: kYellow),
                      child: SizedBox(
                        height: 0.002.h,
                        child: Text(
                          LocaleKeys.question.tr() + '  ${index.toString()}',
                          style: GoogleFonts.almarai(
                              fontSize: 20.sp,
                              color: kYellow,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),*/
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 5.h),
                  width: 364.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.sp),
                    ),
                  ),
                  child: Text(
                    '- ' + question.question.toString()
                    //'jahsejlgbwkebrlgq3v2 42gtwn4tjk;gbn j4q34 th2q4h tiu24gtiyq32triu q24gruigq 34ytq34litr uq42grtiuq24gt yq42uit q42iugtui q24ghtuq42hrtu 2huit qg2h3 wuh4utiq2h4iuthq3u htuiq34htuhq3uity3q9 uytuiq3htiu q3',
                     ,style: GoogleFonts.almarai(
                      fontSize: 18.sp,
                      color: kBlack,
                      fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: question.answers!.map((answer) {
                        return InkWell(
                          onTap: () {
                            cubit.addToAnswerList(
                                qId: question.id, aId: answer.id);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            decoration: BoxDecoration(
                                border: Border.all(color: kBlack),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.sp),
                                ),
                                color: cubit.answersMap[question.id] ==
                                    answer.id
                                    ? kBlack
                                    : kWhite
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: 5.h,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: Container(
                                    width: 15.sp,
                                    height: 15.sp,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color:
                                            cubit.answersMap[question.id] ==
                                                answer.id
                                                ? kBlack
                                                : kBlack,
                                            width: 2),
                                        color: cubit.answersMap[question.id] ==
                                            answer.id
                                            ? kWhite
                                            : null),
                                    child: CircleAvatar(backgroundColor: cubit
                                        .answersMap[question.id] ==
                                        answer.id
                                        ? kBlack
                                        : kWhite),
                                    padding: EdgeInsets
                                        .all(2)
                                        .r,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    answer.answer.toString(),
                                    style: GoogleFonts.almarai(fontSize: 16.sp,
                                      color: cubit.answersMap[question.id] ==
                                          answer.id
                                          ? kWhite
                                          : kBlack,),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
