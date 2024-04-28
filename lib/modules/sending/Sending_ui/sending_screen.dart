import 'dart:io';
import 'dart:ui' as ui;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal/modules/login/cubit/auth_cubit.dart';
import 'package:mal/modules/sending/Sending_ui/previous_messages.dart';
import 'package:mal/modules/sending/audio/sound_player.dart';
import 'package:mal/modules/sending/audio/sound_recorder.dart';
import 'package:mal/shared/components/snack_bar.dart';
import 'package:mal/shared/styles/colors.dart';
import 'package:mal/shared/styles/text_styles.dart';
import 'package:mal/translations/locale_keys.g.dart';

import '../../login/cubit/auth_states.dart';
import '../audio/timer.dart';
import '../cubit/sending_cubit.dart';
import '../cubit/sending_states.dart';

class SendingScreen extends StatefulWidget {
  const SendingScreen({Key? key}) : super(key: key);

  @override
  State<SendingScreen> createState() => _SendingScreenState();
}

class _SendingScreenState extends State<SendingScreen> {
  final message = TextEditingController();
  String? telegramUserName;
  String? whatsAppNumber;

  String ? reContact ;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is GetUserProfileSuccessState) {
          telegramUserName = state.userProfile!.telegramUsername;
          whatsAppNumber = state.userProfile!.phoneNumber;
          reContact = '${whatsAppNumber==null?'':'Whatsapp = https://api.whatsapp.com/send/?phone=$whatsAppNumber\n'}'
          //'Whatsapp = https://api.whatsapp.com/send/?phone=$whatsAppNumber\n'
              '${telegramUserName==null?'':'Telegram = https://t.me/$telegramUserName'}';
        }
      },
      builder: (context, state) {
        var authCubit = AuthCubit.get(context);
        return authCubit.getUserProfileLoading
            ? Center(
                child: CircularProgressIndicator(
                color: kYellow,
              ))
            : BlocConsumer<SendingCubit, SendingStates>(
                listener: (context, state) {
                  if (state is InValidMessageState) {
                    CustomSnackBar.buildErrorSnackBar(
                        context, LocaleKeys.cant_send_empty.tr());
                  }
                },
                builder: (context, state) {
                  var sendingCubit = SendingCubit.get(context);
                  return Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                              width: 395.0.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.0),
                                color: const Color(0xFFDCDCDC),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 10.h),
                                    width: 375.0.w,
                                    //height: 180.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFFEBEBEB),
                                    ),
                                    child: Column(children: [
                                      TextFormField(
                                        autocorrect: false,
                                        controller: message,
                                        onChanged: (v){
                                          sendingCubit.showClearIcon(message.text);
                                        },
                                        style: messageInputTextField,
                                        textDirection:
                                            context.locale == const Locale('ar')
                                                ? ui.TextDirection.rtl
                                                : ui.TextDirection.ltr,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none),
                                        maxLines: 6,
                                        cursorColor:kBlack,
                                      ),
                                      Visibility(
                                        visible: sendingCubit.showClear,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  message.text='';
                                                  sendingCubit.showClearIcon(message.text);
                                                },
                                                icon: Icon(Icons.cancel_outlined))
                                          ],
                                        ),
                                      )
                                    ]),
                                  ),
                                  Container(
                                    height: 60.h,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            sendingCubit.imagePathsList = [];
                                            sendingCubit.imageFileList = [];
                                            sendingCubit.filesPaths = [];
                                            sendingCubit.pressToShowMic();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w, vertical: 2.h),
                                            width: 50.sp,
                                            height: 50.sp,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xFFC2C2C2),
                                              child: Center(
                                                  child: Icon(
                                                Icons.mic_none_outlined,
                                                size: 28.sp,
                                                color: kBlack,
                                              )),
                                            ),
                                          ),
                                        ), //make record
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            sendingCubit.showMic = false;
                                            sendingCubit.filesPaths = [];
                                            sendingCubit.selectImages();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w, vertical: 2.h),
                                            width: 50.sp,
                                            height: 50.sp,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  const Color(0xFFC2C2C2),
                                              child: Center(
                                                  child: Icon(
                                                Icons.image_outlined,
                                                color: kBlack,
                                              )),
                                            ),
                                          ),
                                        ), //attach images
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            sendingCubit.showMic = false;
                                            sendingCubit.imageFileList = [];
                                            sendingCubit.imagePathsList = [];
                                            sendingCubit.selectFiles();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w, vertical: 2.h),
                                            width: 50.sp,
                                            height: 50.sp,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Color(0xFFC2C2C2),
                                              child: Center(
                                                  child: Icon(
                                                Icons.attach_file_outlined,
                                                color: kBlack,
                                              )),
                                            ),
                                          ),
                                        ), //attach files
                                      ],
                                    ),
                                  ),
                                  Mic(cubit: sendingCubit),
                                  BuildSelectImage(
                                    cubit: sendingCubit,
                                  ),
                                  BuildSelectFiles(
                                    cubit: sendingCubit,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        sendingCubit.share(
                                            mMessage: message.text,
                                            reContact: reContact);
                                      }
                                    },
                                    child: Container(
                                      width: 90.w,
                                      height: 40.h,
                                      margin: EdgeInsets.only(
                                          left: 10.w,
                                          right: 10.w,
                                          bottom: 10.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: kBlack,
                                      ),
                                      child: Center(
                                        child: Text(
                                          LocaleKeys.send.tr(),
                                          style: sendButton2Style,
                                        ),
                                      ),
                                    ),
                                  ), //send button
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            PreviousMessages(
                              sendingCubit: sendingCubit,
                              onError: (){
                                sendingCubit.getMessages();
                              },
                              getErrorData: sendingCubit.getMessagesErrorConnection,
                              loading: sendingCubit.getMessageLoading,
                              messages: sendingCubit.messages,
                              onDelete: () {

                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}

class NewImageBuilder extends StatelessWidget {
  final XFile xFile;

  const NewImageBuilder({
    Key? key,
    //required this.apartmentID,
    required this.xFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(7.r),
        ),
        child: Image.file(
          File(xFile.path),
          fit: BoxFit.fill,
          width: double.infinity,
        ),
      ),
    );
  }
}

class BuildSelectImage extends StatelessWidget {
  final cubit;

  const BuildSelectImage({
    Key? key,
    this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final cubit = SendingCubit.get(context);
    return Visibility(
      visible: cubit.imageFileList!.isNotEmpty,
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.0),
          color: const Color(0xFFDCDCDC),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              width: 395.w,
              height: 180.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: const Color(0xFFEBEBEB),
              ),
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  itemCount: cubit.imageFileList!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8),
                  //padding: EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 180.h,
                      child: Stack(children: [
                        NewImageBuilder(
                          xFile: cubit.imageFileList![index],
                        ),
                        Positioned.fill(
                          child: Align(
                            child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: kBlack,
                                ),
                              ),
                              onTap: () {
                                cubit.deleteSelectedImage(index);
                              },
                            ),
                            alignment: context.locale == const Locale('en')
                                ? Alignment.topRight
                                : Alignment.topLeft,
                          ),
                        ),
                      ]),
                    );
                  }),
            ),
          ],
        ),
      ),
    ); //images;
  }
}

class Mic extends StatefulWidget {
  final cubit;

  const Mic({Key? key, this.cubit}) : super(key: key);

  @override
  State<Mic> createState() => _MicState();
}

class _MicState extends State<Mic> {
  final timerController = TimerController();
  final recorder = SoundRecorder();
  final player = SoundPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    player.dispose();
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.cubit.showMic,
      child: Container(
        //height: 180.h,
        margin: EdgeInsets.only(bottom: 15.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: IconButton(
                    iconSize: 27.sp,
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      widget.cubit.pressToHideMic();
                      widget.cubit.value = 0;
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildPlayer(),
                SizedBox(
                  width: 15.w,
                ),
                SizedBox(
                  width: 130.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildStart(),

                      buildPlay(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ); //mic;
  }

  Widget buildPlay() {
    final isPlaying = player.isPlaying;
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? LocaleKeys.stop.tr() : LocaleKeys.play.tr();

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(100.w, 40.h),
        primary: Colors.white,
        onPrimary: Colors.black,
      ),
      icon: Icon(
        icon,
        size: 27.r,
      ),
      label: Text(
        text,
        style: recorderButtons,
      ),
      onPressed: () async {
        if (!recorder.isRecordingAvailable) return;

        await player.togglePlaying(whenFinished: () => setState(() {}));
        setState(() {});
      },
    );
  }

  Widget buildStart() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? LocaleKeys.stop.tr() : LocaleKeys.record.tr();
    final primary = isRecording ? Colors.red : Colors.white;
    final onPrimary = isRecording ? Colors.white : Colors.black;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(130.w, 40.h),
        primary: primary,
        onPrimary: onPrimary,
      ),
      icon: Icon(
        icon,
        size: 27.sp,
      ),
      label: Text(
        text,
        style: recorderButtons,
      ),
      onPressed: () async {
        if (player.isPlaying) return;

        await recorder.toggleRecording();
        final isRecording = recorder.isRecording;
        setState(() {});

        if (isRecording) {
          widget.cubit.value = 1;
          timerController.startTimer();
        } else {
          timerController.stopTimer();
        }
      },
    );
  }

  Widget buildPlayer() {
    final animate = player.isPlaying || recorder.isRecording;

    return AvatarGlow(
      endRadius: 60.sp,
      animate: animate,
      glowColor: kBlack,
      repeatPauseDuration: const Duration(milliseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 50.sp,
          backgroundColor: kYellow,
          //Colors.indigo.shade900.withBlue(70),
          child: player.isPlaying
              ? Icon(
                  Icons.audiotrack_outlined,
                  size: 50.sp,
                  color: kBlack,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mic,
                      size: 32.sp,
                      color: kBlack,
                    ),
                    TimerWidget(controller: timerController),
                    SizedBox(height: 4.h),
                  ],
                ),
        ),
      ),
    );
  }
}

class BuildSelectFiles extends StatelessWidget {
  final cubit;

  const BuildSelectFiles({Key? key, this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: cubit.filesPaths.isNotEmpty,
      child: Container(
        margin:
            EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
        height: 200.h,
        child: Builder(builder: (BuildContext context) {
          return Scrollbar(
              child: ListView.separated(
            itemCount:
                cubit.filesPaths.isNotEmpty ? cubit.filesPaths.length : 1,
            itemBuilder: (BuildContext context, int index) {
              final String filename =
                  'File ${index + 1}: ' + cubit.filesPaths[index].substring(47);
              final path = kIsWeb
                  ? null
                  : cubit.filesPaths.map((e) => e).toList()[index].toString();

              return SizedBox(
                  child: Stack(
                children: [
                  ListTile(
                    title: Text(
                      filename,
                    ),
                    subtitle: Text(path ?? ''),
                  ),
                  Positioned.fill(
                      child: Align(
                    alignment: context.locale == const Locale('ar')
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        print('jjjj');

                        cubit.deleteSelectedFile(index);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 5.h, bottom: 5.h, left: 5.w, right: 5.w),
                        child: CircleAvatar(
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                          backgroundColor: kBlack,
                        ),
                      ),
                    ),
                  )),
                ],
              ));
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ));
        }),
      ),
    ); //files;
  }
}
