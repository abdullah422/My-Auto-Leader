import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_bloc.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_event.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_state.dart';
import 'package:mal/modules/zoom/time/sheet.dart';
import 'package:mal/modules/zoom/time/time_picker.dart';
import 'package:mal/translations/locale_keys.g.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../shared/components/snack_bar.dart';
import '../../shared/styles/colors.dart';
import '../../shared/styles/text_styles.dart';

class CreateMeetingScreen extends StatefulWidget {
  const CreateMeetingScreen({Key? key}) : super(key: key);

  @override
  State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  late CreateMeetBloc createMeetBloc;
  String? selectedDate;
  String? selectedTime;
  String? sentStartTime;
  DateRangePickerController? dateRangePickerController;
  late TextEditingController topicTextController;
  late String currentHour;

  @override
  void initState() {
    super.initState();
    dateRangePickerController = DateRangePickerController();
    dateRangePickerController?.selectedDate = DateTime.now();
    currentHour = DateFormat("HH:mm","en").format(DateTime.now());
    topicTextController = TextEditingController();
    createMeetBloc = CreateMeetBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.create_meeting.tr(),
          style: headingStyle,
        ),
        titleTextStyle: headingStyle,
        centerTitle: true,
        backgroundColor: kYellow,
        elevation: 0,
        toolbarHeight: 78.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.r),
            bottomRight: Radius.circular(25.r),
          ),
        ),
        leadingWidth: 63.w,
        leading: Container(
          height: 18.h,
          width: 14.w,
          margin: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.h),
          padding: const EdgeInsets.all(4),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              height: 16.h,
              width: 14.w,
              child: SvgPicture.asset(
                'assets/svg/arrow_back.svg',
                width: 16.w,
                height: 14.h,
              ),
            ),
          ),
        ),
      ),
      body: BlocListener<CreateMeetBloc, ZoomState>(
        bloc: createMeetBloc,
        listener: (context, state) {
          if(state is CreateMeetingLoadedState){
            if(state.success == true){
              CustomSnackBar.buildSuccessSnackBar(context, LocaleKeys.success_meeting.tr());
              Navigator.of(context).pop();
            }
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsetsDirectional.only(start: 16, top: 16),
                child: Text(
                  LocaleKeys.meeting_topic.tr(),
                  style: GoogleFonts.almarai(textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                margin:
                    const EdgeInsetsDirectional.only(start: 16, end: 16, top: 4),
                child: TextFormField(
                  controller: topicTextController,
                  decoration: InputDecoration(
                      hintText: LocaleKeys.topic,
                      hintStyle: GoogleFonts.almarai(textStyle:const TextStyle(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kYellow),
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kRed),
                      )),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(start: 16, top: 16,),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  LocaleKeys.choose_date.tr(),
                  style: GoogleFonts.almarai(
                      textStyle:const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                margin:
                    const EdgeInsetsDirectional.only(start: 8, end: 8, top: 8),
                child: Theme(
                  data: ThemeData(
                    colorScheme: ColorScheme.fromSwatch()
                        .copyWith(secondary: kYellow, primary: kYellow),
                  ),
                  child: SfDateRangePicker(
                    headerStyle: DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(color: kYellow, fontSize: 16)),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 6,
                    ),
                    todayHighlightColor: kYellow,
                    showNavigationArrow: true,
                    allowViewNavigation: true,
                    enablePastDates: false,
                    selectionColor: kYellow,
                    onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                      DateTime dateTime =
                          dateRangePickerSelectionChangedArgs.value;
                      selectedDate = DateFormat("yyyy-MM-dd","en").format(dateTime);
                      if (selectedTime != null && selectedDate != null) {
                        String temp = selectedDate! + " " + selectedTime!;
                        DateTime d =
                            DateFormat("yyyy-MM-dd HH:mm","en").parse(temp,);
                        d = d.toUtc();
                        sentStartTime = DateFormat("yyyy-MM-dd HH:mm","en").format(d);
                        sentStartTime = sentStartTime?.replaceAll(" ", "");
                        sentStartTime = sentStartTime!.substring(0, 10) +
                            'T' +
                            sentStartTime!.substring(10);
                      }
                    },
                    controller: dateRangePickerController,
                    selectionMode: DateRangePickerSelectionMode.single,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(
                  start: 16,
                ),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  LocaleKeys.choose_time.tr(),
                  style: GoogleFonts.almarai(textStyle:const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
                ),
              ),
              InkWell(
                onTap: () async {
                  DateTime? result = await TimePicker.show<DateTime?>(
                    context: context,
                    dismissible: true,
                    sheet: TimePickerSheet(
                      sheetTitle: LocaleKeys.set_meet_time.tr(),
                      hourTitle: LocaleKeys.hour.tr(),
                      minuteTitle: LocaleKeys.minute.tr(),
                      saveButtonText: LocaleKeys.save.tr(),
                      saveButtonColor: kYellow,
                      wheelNumberSelectedStyle: TextStyle(color: kYellow),
                      hourTitleStyle: TextStyle(color: kYellow),
                      minuteTitleStyle: TextStyle(color: kYellow),
                      sheetCloseIconColor: kYellow,
                      initialDateTime: DateTime.now(),
                    ),
                  );
                  if (result != null) {
                    selectedTime = DateFormat("HH:mm","en").format(result);
                    if (selectedTime != null && selectedDate != null) {
                      String temp = selectedDate! + " " + selectedTime!;
                      DateTime d =
                          DateFormat("yyyy-MM-dd HH:mm","en").parse(temp, );
                      d = d.toUtc();
                      sentStartTime = DateFormat("yyyy-MM-dd HH:mm","en").format(d);
                      sentStartTime = sentStartTime?.replaceAll(" ", "");
                      sentStartTime = sentStartTime!.substring(0, 10) +
                          'T' +
                          sentStartTime!.substring(10);
                    }
                    setState(() {
                      currentHour = selectedTime!;
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsetsDirectional.only(top: 8, start: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsetsDirectional.all(10),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 2),
                        child: Text(
                          currentHour,
                          style: GoogleFonts.almarai(textStyle:const TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Icons.access_time,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocBuilder<CreateMeetBloc, ZoomState>(
                    bloc: createMeetBloc,
                    builder: (context, state) {
                      if(state is CreateMeetingLoadingState){
                        return Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff1c1b21),
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsetsDirectional.only(end: 16, top: 8),
                          padding: const EdgeInsetsDirectional.only(
                              start: 28, end: 28, top: 8, bottom: 8),
                          child: const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }
                      return InkWell(
                        onTap: () {
                          if (topicTextController.text.isNotEmpty == true) {
                            if (dateRangePickerController?.selectedDate == null) {
                              selectedDate ??=
                                  DateFormat("yyyy-MM-dd","en").format(DateTime.now());
                            } else {
                              selectedDate ??= DateFormat("yyyy-MM-dd","en")
                                  .format(dateRangePickerController!.selectedDate!);
                            }
                            selectedTime ??=
                                DateFormat("HH:mm","en").format(DateTime.now());

                            String temp = selectedDate! + " " + selectedTime!;
                            DateTime d =
                            DateFormat("yyyy-MM-dd HH:mm","en").parse(temp, );
                            d = d.toUtc();
                            sentStartTime =
                                DateFormat("yyyy-MM-dd HH:mm","en").format(d);
                            sentStartTime = sentStartTime?.replaceAll(" ", "");
                            sentStartTime = sentStartTime!.substring(0, 10) +
                                'T' +
                                sentStartTime!.substring(10);
                            createMeetBloc.add(CreateMeetEvent(sentStartTime!, topicTextController.text));
                          } else {
                            CustomSnackBar.buildErrorSnackBar( context, LocaleKeys.set_meeting_topic.tr());
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xff1c1b21),
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsetsDirectional.only(end: 16, top: 8),
                          padding: const EdgeInsetsDirectional.only(
                              start: 24, end: 24, top: 8, bottom: 8),
                          child: Text(
                            LocaleKeys.save.tr(),
                            style: GoogleFonts.almarai(textStyle:const TextStyle(color: Colors.white, fontSize: 14)),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}
