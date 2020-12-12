import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jay/models/DownloadModel.dart';
import 'package:jay/models/SongModel.dart';
import 'package:jay/widget/Player.dart';
import 'package:provider/provider.dart';

import 'LrcPage.dart';

class PlayPage extends StatefulWidget {
  final bool nowPlay;

  PlayPage({this.nowPlay});

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController controllerPlayer;
  Animation<double> animationPlayer;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    controllerPlayer = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationPlayer =
        new CurvedAnimation(parent: controllerPlayer, curve: Curves.linear);
    animationPlayer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerPlayer.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerPlayer.forward();
      }
    });
  }

  @override
  void dispose() {
    controllerPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SongModel songModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);

    if (songModel.isPlaying) {
      controllerPlayer.forward();
    } else {
      controllerPlayer.stop(canceled: false);
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      //  AppBarCarousel(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      /* RotatePlayer(
                          animation:
                          _commonTween.animate(controllerPlayer)),*/
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              onPressed: () =>
                                  songModel.setShowList(!songModel.showList),
                              icon: Icon(
                                Icons.list,
                                size: 25.0,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () => songModel.changeRepeat(),
                              icon: songModel.isRepeat == true
                                  ? Icon(
                                      Icons.repeat,
                                      size: 25.0,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.shuffle,
                                      size: 25.0,
                                      color: Colors.white,
                                    ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.favorite_border,
                                size: 25.0,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                debugPrint("下载点击了");
                                debugPrint(songModel.currentSong.toString());
                                if (songModel.currentSong.isLoading) {
                                  return;
                                }
                                downloadModel.download(songModel.currentSong);
                                debugPrint("下载点击了之后");
                                debugPrint(songModel.currentSong.toString());
                              },
                              icon: downloadModel
                                      .isDownload(songModel.currentSong)
                                  ? Icon(
                                      Icons.cloud_done,
                                      size: 25.0,
                                      color: Theme.of(context).accentColor,
                                    )
                                  : songModel.currentSong.isLoading
                                      ? Icon(
                                          Icons.file_download,
                                          size: 25.0,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.cloud_download,
                                          size: 25.0,
                                          color: Colors.white,
                                        ),
                            ),
                          ]),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      Text(
                        "songModel.currentSong.author",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        songModel.currentSong.mName,
                        style: TextStyle(fontSize: 20.0,color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Player(
              songData: songModel,
              downloadData: downloadModel,
              nowPlay: true,
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25.0,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 25.0,
              color: Colors.white,
            ),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
