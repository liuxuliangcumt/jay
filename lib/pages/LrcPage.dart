import 'dart:async';
import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:jay/beans/LrcItemBean.dart';
import 'package:jay/models/SongModel.dart';

class LrcPage extends StatefulWidget {
  SongModel songModel;

  LrcPage(this.songModel);

  @override
  _LrcPageState createState() => _LrcPageState();
}

class _LrcPageState extends State<LrcPage> with AutomaticKeepAliveClientMixin {
  FixedExtentScrollController controller = FixedExtentScrollController();

  SongModel model;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;

  //List<LrcItemBean> lrcBeans;
  //  int currentPosition = 0;
  double itemExtent = 30.0;
  bool isMoved = false;
  Timer timer;

  @override
  void initState() {
    model = widget.songModel;
    _initAudioPlayer(model);
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: model.lrcItemBeans.length != 0
          ? Stack(
              alignment: Alignment.centerRight,
              children: [
                Listener(
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: itemExtent,
                    controller: controller,
                    perspective: 0.001,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        model.currentPosition = index;
                      });
                      debugPrint("onSelectedItemChanged  " + index.toString());
                      /* if (index == model.currentLrc) return;
          model.notifyListeners();
          _audioPlayer.seek(lrcBeans[index].duration);*/
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                        builder: (ct, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width - 60,
                            alignment: Alignment.center,
                            child: isMoved
                                ? model.currentLrc - 1 == index
                                    ? getGradualText(index)
                                    : Text(
                                        model.lrcItemBeans[index].lineContent,
                                        textAlign: TextAlign.center,
                                        style: model.currentPosition == index
                                            ? TextStyle(
                                                color: Colors.amber[400],
                                                fontSize: 18)
                                            : TextStyle(
                                                color: Colors.grey[300],
                                                fontSize: 16),
                                      )
                                : getGradualText(index),
                          );
                        },
                        childCount: model.lrcItemBeans.length),
                  ),
                  onPointerUp: (c) {
                    timer = Timer(Duration(seconds: 3), () {
                      setState(() {
                        isMoved = false;
                        controllerMove(model.currentLrc);
                      });
                    });

                    // todo 本是更改播放进度位置  修改成延时五秒隐藏 时间button
                    print(c.toString());
                    print("onPointerUp");
                  },
                  onPointerDown: (c) {
                    //todo 五秒后发送信号更新
                    setState(() {
                      isMoved = true;
                    });
                    if (timer != null && timer.isActive) {
                      timer.cancel();
                    }
                  },
                ),
                Positioned(
                  right: 50,
                  child: Visibility(
                    child: InkWell(
                      child: Text(
                        getTime(model.lrcItemBeans[model.currentPosition]),
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        if (!model.isPlaying) {
                          resume();
                        }
                        if ((model.currentPosition - model.currentLrc).abs() >
                            3) {
                          _audioPlayer.seek(model
                              .lrcItemBeans[model.currentPosition].duration);
                          model.currentLrc = model.currentPosition;
                          model.notifyListeners();
                        }
                      },
                    ),
                    visible: isMoved,
                  ),
                ),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: Text(
                '暂无歌词',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
    );
  }

  void resume() async {
    final result = await _audioPlayer.resume();
    if (result == 1) setState(() => model.setPlaying(true));
  }

  void _initAudioPlayer(SongModel songModel) {
    _audioPlayer = songModel.audioPlayer;

    _audioPlayer.onAudioPositionChanged.listen((duration) {
      int curren = model.currentLrc;
      if (curren < model.lrcItemBeans.length &&
          duration.inMilliseconds >
              model.lrcItemBeans[curren].duration.inMilliseconds) {
        changController();
      }
    });
  }

  void changController() {
    int curren = model.currentLrc;
    model.setCurrentIndexAdd();
    if (isMoved) return;
    controllerMove(curren + 1);
  }

//
  String getTime(LrcItemBean lrcBean) {
    if (lrcBean.lrcTime.length > 5) {
      return lrcBean.lrcTime.substring(0, 5);
    } else {
      return "";
    }
  }

  void controllerMove(int currentLrc) {
    controller.animateTo(
      currentLrc * itemExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInCubic,
    );
  }

  getGradualText(int index) {
    /* Text(
      model.lrcItemBeans[index].lineContent,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.amber[400],
          fontSize: 18),
    )*/
//todo 渐变

    return Text(
      model.lrcItemBeans[index].lineContent,
      textAlign: TextAlign.center,
      style: model.currentLrc - 1 == index
          ? TextStyle(color: Colors.amber[400], fontSize: 18)
          : TextStyle(color: Colors.grey[300], fontSize: 16),
    );
  }
}
