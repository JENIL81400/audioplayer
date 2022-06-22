
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';


class second extends StatefulWidget {
  List<SongModel>? songList;
  int? pos;
  second({ this.songList, this.pos});
  @override
  State<second> createState() => _secondState();
}
class _secondState extends State<second> {
  SongModel? s;
  bool play =true;
  AudioPlayer audioPlayer=AudioPlayer();
  double currentval=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      s=widget.songList![widget.pos!];
    });
    print("${s!.getMap}");
    playsong(s!);

    // audioPlayer.onDurationChanged.listen((event) {
    //
    //   print("onduration = $event");
    // });
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        currentval=event.inMilliseconds.toDouble();
      });
      print("onaudio = $event");
    });
    audioPlayer.onPlayerCompletion.listen((event) async {
      await audioPlayer.pause();
      setState(() {
        play=true;
        widget.pos=widget.pos!+1;
        s=widget.songList![widget.pos!];
      });

      print("${s!.getMap}");
      playsong(s!);
    });

  }
  String _printDuration(Duration duration)  {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
  playsong(SongModel songModel) async
  {
    await audioPlayer.play(songModel.getMap['_data'],isLocal: true);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await audioPlayer.pause();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(title: Text("${s!.title}"),),
              ListTile(title: Text("Album=${s!.album}"),),
              ListTile(title: Text("Artist=${s!.artist}"),),
              ListTile(title: Text("DisplayName=${s!.displayName}"),),
              ListTile(title: Text("Duration=${s!.duration}"),),
              ListTile(
                trailing: Text(_printDuration(Duration(milliseconds: s!.duration!))),
                title: Text(_printDuration(Duration(milliseconds: currentval.toInt()))),
              ),
              Slider(
                value: currentval,
                min: 0,
                max: s!.duration!.toDouble(),
                onChanged: (value) async {
                  setState(() {
                    play=false;
                    currentval=value;
                  });
                  await audioPlayer.pause();
                },
                onChangeStart: (value) async {

                  await audioPlayer.pause();
                },
                onChangeEnd: (value)
                async {
                  setState(() {
                    play=true;
                    currentval=value;
                  });
                  await audioPlayer.seek(Duration(milliseconds: value.toInt()));
                  await audioPlayer.resume();
                },

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: () async {
                    await audioPlayer.pause();
                    setState(() {
                      play=true;
                      widget.pos=widget.pos!-1;
                      s=widget.songList![widget.pos ?? 0];
                    });

                    print("${s!.getMap}");
                    playsong(s!);
                  }, icon: Icon(Icons.skip_previous_outlined)),
                  play?IconButton(onPressed: () async {
                    await audioPlayer.pause();
                    setState(() {
                      play=false;
                    });

                  }, icon: Icon(Icons.pause)):
                  IconButton(onPressed: () async {
                    await audioPlayer.resume();

                    setState(() {
                      play=true;
                    });
                  }, icon: Icon(Icons.play_arrow)),
                  IconButton(onPressed: () async {

                    await audioPlayer.pause();
                    setState(() {
                      play=true;
                      widget.pos=widget.pos!+1;
                      s=widget.songList![widget.pos!];
                    });

                    print("${s!.getMap}");
                    playsong(s!);
                  }, icon: Icon(Icons.skip_next_outlined))
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}

