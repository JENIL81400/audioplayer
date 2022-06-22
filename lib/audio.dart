
import 'package:audioplayer/second.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class audio extends StatefulWidget {

  @override
  State<audio> createState() => _audioState();

}
class _audioState extends State<audio> {

  bool play=false;
  List<SongModel>list=[];
  OnAudioQuery _audioQuery = OnAudioQuery();
  AudioPlayer audioPlayer = AudioPlayer();
  Future<List<SongModel>>getsongs() async {
     await _audioQuery.querySongs().then((value) {
       list=value;
     });
     return list;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getsongs();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  ),
      body: FutureBuilder(
        future: getsongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<SongModel> songlist = snapshot.data as List<SongModel>;

            return ListView.builder(
              itemCount: songlist.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${songlist[index].title}"),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return second(pos: index,songList: songlist);
                    },));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
