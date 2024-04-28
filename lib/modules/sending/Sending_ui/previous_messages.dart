import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mal/model/message_model.dart';
import 'package:mal/modules/sending/cubit/sending_cubit.dart';
import 'package:mal/shared/components/error_network_connection.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../../shared/components/snack_bar.dart';

class PreviousMessages extends StatelessWidget {
  final List<Message> messages;
  final bool loading;
  final bool getErrorData;
  final Function onDelete;
  final Function onError;
  final SendingCubit sendingCubit;

  const PreviousMessages(
      {Key? key,
      required this.messages,
      required this.loading,
      required this.onDelete,
      required this.getErrorData,
      required this.onError, required this.sendingCubit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 66.h,
          child: Container(
            width: 395.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.sp),
                  topRight: Radius.circular(12.sp),
                  bottomRight: Radius.circular(12.sp),
                  bottomLeft: Radius.circular(12.sp),
                ),
                color: const Color(0xFFDCDCDC)),
            child: Center(
              child: Text(
                LocaleKeys.previous_messages.tr(),
                style: titleStyle,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 353.h,
          width: 395.w,
          child: loading
              ? getErrorData
                  ? ErrorNetworkConnection(
                      onCallback: onError,
                      fromAlert: true,
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: kYellow,
                      ),
                    )
              : messages.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/no_messages.svg',
                          height: 170.h,
                          width: 150.w,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                            child: Text(
                          LocaleKeys.no_messages.tr(),
                          style: titleStyle,
                        )),
                      ],
                    )
                  : ListView.builder(
                      itemBuilder: (_, index) {
                        return Container(
                          margin: EdgeInsets.only(top: 10.h),
                          height: 100.h,
                          decoration: BoxDecoration(
                              color: const Color(0xFFEBEBEB),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.sp))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: 8.h,
                                    bottom: 8.h,
                                    right: 8.w,
                                  ),
                                  child: SizedBox(
                                    child: SingleChildScrollView(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8).r,
                                      child: Text(
                                          messages[index].mContent!.toString()),
                                    )),
                                  ),
                                ),
                              ),
                              Container(
                                height: 80.h,
                                width: 30.w,
                                margin: EdgeInsets.symmetric(horizontal: 6.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: messages[index]
                                                      .mContent
                                                      .toString()))
                                              .then((value) {
                                            CustomSnackBar.buildSuccessSnackBar(
                                              context,
                                              LocaleKeys.message_copied.tr(),
                                            );
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/svg/copy.svg',
                                          width: 20.w,
                                          height: 25.h,
                                        )),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        sendingCubit.deleteMessage(messages[index]);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/svg/delete.svg',
                                        width: 25.w,
                                        height: 28.h,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: messages.length),
        ),
      ],
    );
  }
}
