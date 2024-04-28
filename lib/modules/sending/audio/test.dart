/*
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestAudio extends StatefulWidget {
  const TestAudio({Key? key}) : super(key: key);

  @override
  State<TestAudio> createState() => _TestAudioState();
}

class _TestAudioState extends State<TestAudio> {
  late final RecorderController recorderController;
  late PlayerController playerController;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController();
    playerController = PlayerController();
  }
  late String ? path ;

  void _playOrPlausePlayer(PlayerController controller) async {
    controller.playerState == PlayerState.playing
        ? await controller.pausePlayer()
        : await controller.startPlayer(finishMode: FinishMode.stop);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 200.h,
            ),
            SizedBox(
              height: 80.h,
              width: 400.w,
              child: AudioWaveforms(
                waveStyle: WaveStyle(
                  bottomPadding: 40.h,

                  waveColor: Colors.red,
                  //showDurationLabel: true,
                  spacing: 7,
                  //showBottom: false,
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
                size: Size(MediaQuery.of(context).size.width, 200.0),
                recorderController: recorderController,
              ),
            ),
          TextButton(
              onPressed: () async {
                await recorderController.record();
              },
            child: Text('record'),
            ),
            TextButton(
              onPressed: () async {
                await recorderController.pause();
              },
              child: Text('pause'),
            ),
            TextButton(
              onPressed: () async {
                 path = await recorderController.stop();
                 print("path55"+path.toString());

              },
              child: Text('stop'),
            ),
            TextButton(
              onPressed: () async {
                await playerController.preparePlayer(path!);
                await playerController.startPlayer();
               
                setState(() {


                });


                //await playerController.stopPlayer();
              },
              child: Text('play'),
            ),
            TextButton(
              onPressed: () async {
                await playerController.pausePlayer();
                //await playerController.stopPlayer();
              },
              child: Text('pause'),
            ),
            Container(
              color: Colors.black54,
              height: 100.h,
              width: 100,
              child:  AudioFileWaveforms(
                size: Size(MediaQuery.of(context).size.width /1.5, 80),
                playerController: playerController,
                density: 1.7,
                playerWaveStyle: const PlayerWaveStyle(
                  scaleFactor: 0.7,
                  fixedWaveColor: Colors.white30,
                  liveWaveColor: Colors.white,
                  waveCap: StrokeCap.round,
                ),
              ),
            ),
            WaveBubble(
              playerController: playerController,
              isPlaying: playerController.playerState == PlayerState.playing,
              onTap: () => _playOrPlausePlayer(playerController),
            ),

            */
/*if (playerController.playerState != PlayerState.stopped) ...[

            ],*//*

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    recorderController.dispose();
    playerController.dispose();

    super.dispose();
  }
}
class WaveBubble extends StatelessWidget {
  final PlayerController playerController;
  final VoidCallback onTap;
  final bool isSender;
  final bool isPlaying;

  const WaveBubble({
    Key? key,
    required this.playerController,
    required this.onTap,
    required this.isPlaying,
    this.isSender = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 6,
          right: isSender ? 0 : 10,
          top: 6,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSender ? const Color(0xFF276bfd) : const Color(0xFF343145),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onTap,
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              color: Colors.white,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width /1.5, 80),
              playerController: playerController,
              density: 1.7,
              playerWaveStyle: const PlayerWaveStyle(
                scaleFactor: 0.7,
                fixedWaveColor: Colors.white30,
                liveWaveColor: Colors.white,
                waveCap: StrokeCap.round,
              ),
            ),
            if (isSender) const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}*/
