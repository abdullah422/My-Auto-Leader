import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_meetings_bloc.dart';
import 'package:mal/modules/zoom/previous_meeting_item.dart';

import '../../shared/styles/colors.dart';
import 'bottom_loader.dart';
import 'cubit/bloc/zoom_event.dart';
import 'cubit/bloc/zoom_state.dart';


class PreviousMeetingsList extends StatefulWidget {
  const PreviousMeetingsList({Key? key}) : super(key: key);

  @override
  State<PreviousMeetingsList> createState() => _PreviousMeetingsListState();
}

class _PreviousMeetingsListState extends State<PreviousMeetingsList> {
  late ZoomMeetingsBloc zoomMeetingsBloc;
  late ScrollController scrollController;
  late bool isLoading;
  @override
  void initState() {
    super.initState();
    zoomMeetingsBloc = ZoomMeetingsBloc();
    scrollController = ScrollController();
    isLoading = true;
    scrollController.addListener(_onScroll);
    zoomMeetingsBloc.add(
        GetMeetingsEvent(0,"10","1"));
  }

  void _onScroll() {
    if(scrollController.hasClients) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll <= 200.0 && !isLoading) {
        isLoading = true;
        zoomMeetingsBloc.add(
            GetMeetingsEvent(0,"10","1"));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZoomMeetingsBloc, ZoomState>(
      bloc: zoomMeetingsBloc,
      builder:(context, state) {
        if(state is MeetingLoadedState){
          isLoading = false;
          int itemsCount = state.meets?.length??0;
          if(state.hasMore == true) {
            itemsCount++;
          }
          return  ListView.builder(
            itemCount: itemsCount,
            controller: scrollController,
            padding: const EdgeInsetsDirectional.only(bottom: 64),
            itemBuilder: (context, index) {
              if(index == itemsCount-1&&state.hasMore==true) {
                return const BottomLoader();
              }
              return PreviousMeetingItem(state.meets![index]);
            },);
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
    );
  }
  String convertToLocalDate(String? startTime) {
    if(startTime!=null){
      DateTime d = DateFormat("yyyy-MM-dd HH:mm:ss","en").parse(startTime, true);
      d = d.toLocal();
      return DateFormat("yyyy/MM/dd HH:mm","en").format(d);
    }
    return "";
  }
}
