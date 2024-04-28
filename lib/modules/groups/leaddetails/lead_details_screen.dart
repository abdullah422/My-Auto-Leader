import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/modules/groups/leaddetails/bloc/bloc.dart';
import 'package:mal/modules/groups/leaddetails/notes/notes_tab.dart';
import 'package:mal/modules/groups/leaddetails/tasks/tasks_tab.dart';
import 'package:mal/translations/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/styles/colors.dart';
import '../../../shared/styles/text_styles.dart';

class LeadDetailsScreen extends StatefulWidget {
  const LeadDetailsScreen(this.leaderId, {Key? key}) : super(key: key);
  final int? leaderId;

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _allTabsController;
  late LeadDetailsCubit leadDetailsCubit;

  @override
  void initState() {
    super.initState();
    leadDetailsCubit = LeadDetailsCubit();
    leadDetailsCubit.getContactDetails(widget.leaderId ?? 0);
    _allTabsController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.leader_information.tr(),
          style: headingStyle,
        ),
        titleTextStyle: headingStyle,
        centerTitle: false,
        backgroundColor: kYellow,
        elevation: 0,
        toolbarHeight: 64,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.r),
            bottomRight: Radius.circular(25.r),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 35.sp,
            color: kBlack,
          ),
        ),
      ),
      body: BlocBuilder<LeadDetailsCubit, LeadDetailsState>(
        bloc: leadDetailsCubit,
        builder: (context, state) {
          if (state is LoadedLeadDetailsState) {
            if (state.success) {
              return Column(
                children: [
                  Container(
                      margin: const EdgeInsetsDirectional.only(
                          top: 16, start: 16, end: 16),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: kGray,
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                margin: const EdgeInsetsDirectional.only(
                                    top: 16, ),
                                alignment: AlignmentDirectional.center,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle),
                                child: Text(
                                  "${state.data?.givenName?.substring(0, 1).toUpperCase() ?? ""}"
                                  "${state.data?.familyName?.substring(0, 1).toUpperCase() ?? ""}",
                                  style: GoogleFonts.almarai(
                                      fontSize: 21,
                                      color: kBlack,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              PositionedDirectional(
                                bottom: 2,
                                  start: 2,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: getColor(state.data?.status),
                                      shape: BoxShape.circle
                                    ),
                                  )
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(state.data?.displayName ?? "",
                              style: titleBlackStyle),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                              state.data?.phones?.isNotEmpty == true
                                  ? state.data?.phones![0].value ?? ""
                                  : "",
                              style: GoogleFonts.almarai(
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                          ),
                          const SizedBox(height: 16,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                  if(state.data?.phones?.isNotEmpty == true){
                                    final Uri phoneLaunchUri = Uri(
                                      scheme: 'tel',
                                      path: state.data?.phones![0].value,
                                    );
                                    launchUrl(phoneLaunchUri);
                                  }

                                },
                                child: Row(
                                  children: const [
                                    Icon(Icons.call),
                                    // Text(LocaleKeys.call.tr(),
                                    //   style: questionBodyStyle,)
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  if(state.data?.phones?.isNotEmpty == true){
                                    final Uri smsLaunchUri = Uri(
                                      scheme: 'sms',
                                      path: state.data?.phones![0].value,
                                    );
                                    launchUrl(smsLaunchUri);
                                  }
                                },
                                child: Row(
                                  children: const [
                                    Icon(Icons.sms),
                                    SizedBox(width: 4,),
                                    // Text(LocaleKeys.sms.tr(),
                                    //   style: questionBodyStyle,)
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  if(state.data?.emails?.isNotEmpty == true){
                                    final Uri emailLaunchUri = Uri(
                                      scheme: 'mailto',
                                      path: state.data?.emails![0].value,
                                    );
                                    launchUrl(emailLaunchUri);
                                  }

                                },
                                child: Row(
                                  children: const [
                                    Icon(Icons.mail),
                                    SizedBox(width: 4,),
                                    // Text(LocaleKeys.mail.tr(),
                                    //   style: questionBodyStyle,)
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                  Container(
                    height: 48,
                    margin:
                        const EdgeInsetsDirectional.only(start: 16, end: 16),
                    child: TabBar(
                      tabs: [
                        Tab(
                          text: LocaleKeys.tasks.tr(),
                        ),
                        Tab(
                          text: LocaleKeys.notes.tr(),
                        )
                      ],
                      indicatorColor: kBlack,
                      indicatorWeight: 3,
                      labelStyle: GoogleFonts.almarai(
                        textStyle: TextStyle(fontSize: 16.sp),
                      ),
                      controller: _allTabsController,
                      labelColor: kBlack,
                      unselectedLabelColor: Colors.black26,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 352,
                    child: TabBarView(
                      controller: _allTabsController,
                      children: [
                        TasksTab(widget.leaderId ?? 0),
                        NotesTab(widget.leaderId ?? 0)
                      ],
                    ),
                  )
                ],
              );
            }
          }
          return Container(
            margin: const EdgeInsets.only(top: 16),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: kYellow,
              ),
            ),
          );
        },
      ),
    );
  }

  getColor(String? status) {
    if(status == "cold") {
      return Colors.blue;
    }
    if(status == "warm"){
      return Colors.yellow;
    }
    if(status == "hot") {
      return Colors.red;
    }
    return Colors.black;
  }
}
