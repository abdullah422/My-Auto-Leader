import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../shared/styles/colors.dart';

class DatePicker extends StatefulWidget {
  const DatePicker(this.callback, {Key? key}) : super(key: key);
  final Function(String?) callback;
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Theme(
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
                maxDate: DateTime.now(),
                showNavigationArrow: true,
                allowViewNavigation: true,
                enablePastDates: true,

                selectionColor: kYellow,
                onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                  DateTime dateTime =
                      dateRangePickerSelectionChangedArgs.value;
                  String? selectedDate = DateFormat("yyyy-MM-dd","en").format(dateTime);
                  widget.callback(selectedDate);
                },
                selectionMode: DateRangePickerSelectionMode.single,
              ),
            ),
          ],
        ),
    );
  }
}
