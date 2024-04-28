import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/modules/zoom/cubit/bloc/update_meeting_bloc.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_event.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_meetings_bloc.dart';
import 'package:mal/modules/zoom/cubit/bloc/zoom_state.dart';
import 'package:mal/modules/zoom/upmeeting_meeting_item.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bottom_loader.dart';

class UpcomingMeetingsList extends StatefulWidget {
  const UpcomingMeetingsList(this.zoomMeetingsBloc, {Key? key})
      : super(key: key);
  final ZoomMeetingsBloc zoomMeetingsBloc;

  @override
  State<UpcomingMeetingsList> createState() => _UpcomingMeetingsListState();
}

class _UpcomingMeetingsListState extends State<UpcomingMeetingsList> {
  late ScrollController scrollController;
  late bool isLoading;
  late WebViewController webController;
  late UpdateMeetingBloc updateMeetingBloc;

  @override
  void initState() {
    super.initState();
    updateMeetingBloc = UpdateMeetingBloc();
    scrollController = ScrollController();
    isLoading = true;
    scrollController.addListener(_onScroll);
    widget.zoomMeetingsBloc.add(GetMeetingsEvent(1, "10", "1"));
  }

  void _onScroll() {
    if (scrollController.hasClients) {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      if (maxScroll - currentScroll <= 200.0 && !isLoading) {
        isLoading = true;
        widget.zoomMeetingsBloc.add(GetMeetingsEvent(1, "10", "1"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZoomMeetingsBloc, ZoomState>(
      bloc: widget.zoomMeetingsBloc,
      builder: (context, state) {
        if (state is MeetingLoadedState) {
          isLoading = false;
          int itemsCount = state.meets?.length ?? 0;
          if (state.hasMore == true) {
            itemsCount++;
          }
          return Stack(
            children: [

              ListView.builder(
                itemCount: itemsCount,
                controller: scrollController,
                padding: const EdgeInsetsDirectional.only(bottom: 64),
                itemBuilder: (context, index) {
                  if (index == itemsCount - 1 && state.hasMore == true) {
                    return const BottomLoader();
                  }
                  return UpcomingMeetingItem(
                    state.meets![index],
                    (url, meetingId) async{
                      print(url);
                      // await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
                      // setState(() {
                      //   webController.loadUrl(url);
                      // });
                      // await Future.delayed(const Duration(seconds: 6));
                      // updateMeetingBloc.add(UpdateMeetEvent(meetingId));
                    },
                  );
                },
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   height: 200,
              //   child: WebView(
              //     initialUrl: '',
              //     javascriptMode: JavascriptMode.unrestricted,
              //     onWebViewCreated: (controller) {
              //       webController = controller;
              //     },
              //     onPageStarted: (url) {
              //       print(url);
              //     },
              //   ),
              // ),
            ],
          );
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
}
