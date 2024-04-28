import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mal/modules/zoom/previous_meetings_list.dart';
import 'package:mal/modules/zoom/upcoming_meetings_list.dart';
import 'package:mal/shared/components/app_routes.dart';

import '../../shared/styles/colors.dart';
import '../../shared/styles/text_styles.dart';
import '../../translations/locale_keys.g.dart';
import 'cubit/bloc/zoom_event.dart';
import 'cubit/bloc/zoom_meetings_bloc.dart';
import 'cubit/bloc/zoom_state.dart';
import 'cubit/bloc/zoom_sync_bloc.dart';

class ZoomScreen extends StatefulWidget {
  const ZoomScreen({Key? key}) : super(key: key);

  @override
  State<ZoomScreen> createState() => _ZoomScreenState();
}

class _ZoomScreenState extends State<ZoomScreen> with SingleTickerProviderStateMixin {

  late TabController _allTabsController;
  late ZoomMeetingsBloc upcomingBloc;
  late ZoomSyncBloc zoomSyncBloc;

  @override
  void initState() {
    super.initState();
    upcomingBloc = ZoomMeetingsBloc();
    _allTabsController = TabController(length: 2, vsync: this);
    zoomSyncBloc = ZoomSyncBloc();
    zoomSyncBloc.add(SyncZoom());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ZoomSyncBloc, ZoomState>(
          bloc: zoomSyncBloc,
          builder: (context, state) {
            if(state is SyncLoadedState){
              if(state.success == true){
                return Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 48,
                          margin: const EdgeInsetsDirectional.only(start: 16, end: 16),
                          child: TabBar(
                            tabs: [
                              Tab(
                                text: LocaleKeys.upcoming.tr(),
                              ),Tab(
                                text: LocaleKeys.previous.tr(),
                              )
                            ],
                            indicatorColor: kBlack,
                            indicatorWeight: 3,
                            labelStyle: GoogleFonts.almarai(textStyle: const TextStyle(
                                fontSize: 13
                            ),),
                            controller: _allTabsController,
                            labelColor: kBlack,
                            unselectedLabelColor: Colors.black26,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 209,
                          child: TabBarView(
                            controller: _allTabsController,
                            children: [
                              UpcomingMeetingsList(upcomingBloc),
                              const PreviousMeetingsList(),

                            ],
                          ),
                        )
                      ],
                    ),
                    PositionedDirectional(
                      bottom: 8,
                      end: 4,
                      start: 4,
                      child: InkWell(
                        onTap: () async{
                          await Navigator.of(context).pushNamed(AppRoutes.createMeeting);
                          upcomingBloc.add(ResetMeetingList());
                          upcomingBloc.add(GetMeetingsEvent(1, "10", "1"));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: AlignmentDirectional.center,
                          padding: const EdgeInsetsDirectional.only(top: 16, bottom: 16),
                          decoration: BoxDecoration(
                              color: kBlack,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          margin: const EdgeInsetsDirectional.only(start: 12, end: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.create_meeting.tr(),
                                style: GoogleFonts.almarai(textStyle: const TextStyle(
                                    color: Colors.white
                                ),),),
                              const SizedBox(width: 4,),
                              SvgPicture.asset(
                                'assets/svg/create_meeting.svg',
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Container(
                  margin: const EdgeInsetsDirectional.only(start: 24, end: 24),
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    state.message,
                    style: headingStyle,
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(
                color: kYellow,
              ),
            );
          },
        )
      ),
    );
  }
}
