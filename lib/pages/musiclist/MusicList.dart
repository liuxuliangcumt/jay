import 'dart:async';
import 'dart:io';

import 'package:audioplayer/audioplayer.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jay/beans/Music.dart';
import 'package:jay/common/PhoneInfo.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicList extends StatefulWidget {
  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  List<String> bannerList = [
    "http://imagescumt.test.upcdn.net/musicBanner/banner1.jpg",
    "http://imagescumt.test.upcdn.net/musicBanner/banner2.jpg",
    "http://imagescumt.test.upcdn.net/musicBanner/banner3.jpg"
  ];
  List<String> tabBarTitles = [
    "jay",
    "范特西",
    "八度空间",
    "叶惠美",
    "七里香",
    "十一月的肖邦",
    "依然范特西",
    "我很忙",
    "摩杰座",
    "跨时代",
    "惊叹号",
    "十二新作",
    "哎呦，不错哦",
    "周杰伦的床边故事",
  ];

  AudioPlayer audioPlayer;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    audioPlayer = AudioPlayer();
    initPlayer();
    //getMusicList("jay");
    if (Platform.isIOS) {
      tabBarTitles.clear();
      tabBarTitles.add("jay");
    } else if (Platform.isAndroid) {}
    _checkPermission();
  }

  AudioPlayerState playerState;
  var _positionSubscription, _audioPlayerStateSubscription, position, duration;

  void initPlayer() {
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));

    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      print(" 播放器状态改变了 $s");
      setState(() {
        playerState = s;
      });
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        //   onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = AudioPlayerState.STOPPED;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

// 申请权限
  Future<bool> _checkPermission() async {
    // 先对所在平台进行判断
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarTitles.length,
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              BannerSwiper(
                //width  和 height 是图片的高宽比  不用传具体的高宽   必传
                height: 108,
                width: 54,
                length: bannerList.length,
                getwidget: (index) {
                  return new GestureDetector(
                      child: Image.network(
                        bannerList[index % bannerList.length],
                        fit: BoxFit.cover,
                      ),
                      onTap: () {});
                },
              ),
              Padding(
                child: TabBar(
                  labelPadding: EdgeInsets.all(10),
                  tabs: getTabs(),
                  unselectedLabelColor: Colors.grey,
                  //设置未选中时的字体颜色，tabs里面的字体样式优先级最高
                  unselectedLabelStyle: TextStyle(fontSize: 20),
                  //设置未选中时的字体样式，tabs里面的字体样式优先级最高
                  labelColor: Colors.black,
                  //设置选中时的字体颜色，tabs里面的字体样式优先级最高
                  labelStyle: TextStyle(fontSize: 20.0),
                  //设置选中时的字体样式，tabs里面的字体样式优先级最高
                  isScrollable: true,
                  //允许左右滚动
                  indicatorColor: Colors.red,
                  //选中下划线的颜色
                  indicatorSize: TabBarIndicatorSize.label,
                  //选中下划线的长度，label时跟文字内容长度一样，tab时跟一个Tab的长度一样
//                indicator: BoxDecoration(),//用于设定选中状态下的展示样式
                ),
                padding: EdgeInsets.only(left: 10, right: 10),
              ),
              Expanded(
                child: TabBarView(
                  children: getTabBarViews(),
                ),
              ),
              playItem()
            ],
          ),
        ),
      ),
    );
  }

  Map musicAlbum = new Map();

//获取音乐列表数据
  Widget getMusicList(String s) {
    List<jayMusic> musics = new List();
    BmobQuery<jayMusic> query = BmobQuery();
    query.addWhereEqualTo("album", s);
    query.queryObjects().then((data) {
      musics = data.map((i) => jayMusic.fromJson(i)).toList();
      if (musics.length > 0) {
        if (Platform.isIOS) {
          musics.clear();
          musics.add(data.map((i) => jayMusic.fromJson(i)).toList()[0]);
        }
      }

      setState(() {
        musicAlbum[s] = musics;
      });
      for (jayMusic blog in musics) {
        if (blog != null) {
          print(blog.objectId);
          print(blog.mName);
          print(blog.urlPath);
        }
      }
    }).catchError((e) {
      // showError(context, BmobError.convert(e).error);
    });
  }

  jayMusic music;

//获取音乐列表
  Widget getMusicListItem(String s) {
    if (musicAlbum.containsKey(s)) {
      List<jayMusic> musics = musicAlbum[s];
      return ListView.separated(
          itemCount: musics.length,
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 1.0, color: Colors.grey),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: ListTile(
                onTap: () {
                  if (currentIndex == index) {
                    return;
                  }
                  setState(() {
                    currentIndex = index;
                    music = musics[index];
                  });

                  String url = musics[index].urlPath;
                  print(" ${musics[index].mName} 点击了：$url  ");
                  playMusic(url);
                },
                title: Text(
                  musics[index].mName,
                  style: TextStyle(
                      color: currentIndex == index
                          ? Colors.lightGreen
                          : Colors.black),
                ),
                leading: Icon(
                  Icons.library_music,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            );
          });
    } else {
      getMusicList(s);
      return Container();
    }
  }

  Future<void> playMusic(String url) async {
    // 设置边下边播
    audioPlayer.pause();
    audioPlayer.play(url);
    audioPlayer.seek(duration);
    downloadFile(url, PhoneInfo.findLocalPath(context));
  }

// 根据 downloadUrl 和 savePath 下载文件
  downloadFile(downloadUrl, savePath) async {
    print("进入下载文件");
    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: savePath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

//底部播放控制行
  Widget playItem() {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 15, bottom: 8),
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Image.network(
              bannerList[0],
              width: 50,
              height: 50,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              music == null ? "" : music.mName,
            ),
          ),
          GestureDetector(
            child: Icon(
              (playerState == AudioPlayerState.STOPPED ||
                      playerState == AudioPlayerState.PAUSED)
                  ? Icons.play_arrow
                  : Icons.stop,
              size: 35,
            ),
            onTap: () {
              if (playerState == AudioPlayerState.PLAYING) {
                audioPlayer.pause();
              } else {
                if (music != null) {
                  playMusic(music.urlPath);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> getTabs() {
    List<Widget> tabs = new List();

    for (var i = 0; i < tabBarTitles.length; i++) {
      tabs.add(Text(tabBarTitles[i]));
    }
    return tabs;
  }

  List<Widget> getTabBarViews() {
    List<Widget> barViews = List();
    for (var i = 0; i < tabBarTitles.length; i++) {
      barViews.add(getMusicListItem(tabBarTitles[i]));
    }
    return barViews;
  }
}
