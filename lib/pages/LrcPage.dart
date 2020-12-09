import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:jay/beans/LrcItemBean.dart';
import 'package:jay/models/SongModel.dart';
import 'package:provider/provider.dart';

class LrcPage extends StatefulWidget {
  SongModel songModel;

  LrcPage(this.songModel);

  @override
  _LrcPageState createState() => _LrcPageState();
}

class _LrcPageState extends State<LrcPage> {
  ScrollController controller = ScrollController();
  SongModel model;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  List<LrcItemBean> lrcBeans;

  @override
  void initState() {
    model = widget.songModel;
    _initAudioPlayer(model);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: 200,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 30,
        controller: controller,
        perspective: 0.001,
        onSelectedItemChanged: (index) {},
        childDelegate: ListWheelChildBuilderDelegate(
            builder: (ct, index) {
              return Text(
                lrcBeans[index].lineContent,
                style: model.currentLrc == index
                    ? TextStyle(color: Colors.white, fontSize: 18)
                    : TextStyle(color: Colors.grey[350], fontSize: 16),
              );
            },
            childCount: lrcBeans.length),
      ),
    );
  }

  void _initAudioPlayer(SongModel songModel) {
    lrcBeans = songModel.lrcItemBeans;
    _audioPlayer = songModel.audioPlayer;

    _audioPlayer.onAudioPositionChanged.listen((duration) {
      if (model.currentLrc < lrcBeans.length - 1 &&
          duration.inMilliseconds >
              lrcBeans[model.currentLrc].duration.inMilliseconds) {
        debugPrint("监听  位置 onAudioPositionChanged   进来了");

        debugPrint(duration.toString());
        model.setCurrentIndexAdd();
        controller.animateTo(
          model.currentLrc * 30.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linearToEaseOut,
        );
      }
    });
  }
}
