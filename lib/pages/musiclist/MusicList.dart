import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:jay/beans/Music.dart';
import 'package:jay/common/PhoneInfo.dart';
import 'package:jay/models/DownloadModel.dart';
import 'package:jay/models/SongModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../PlayPage.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initDownLoader();

    //getMusicList("jay");
    if (Platform.isIOS) {
      tabBarTitles.clear();
      tabBarTitles.add("jay");
    } else if (Platform.isAndroid) {
      /* tabBarTitles.clear();
      tabBarTitles.add("jay");*/
    }
    _checkPermission();
  }

  AudioPlayerState playerState;
  var _positionSubscription, _audioPlayerStateSubscription, position;

  var duration;

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
            ],
          ),
        ),
      ),
    );
  }

  Map musicAlbum = new Map();

//获取音乐列表数据
  Widget getMusicList(String s) {
    List<Song> musics = new List();
    BmobQuery<jayMusic> query = BmobQuery();
    query.addWhereEqualTo("album", s);
    query.queryObjects().then((data) {
      musics = data.map((i) => Song.fromJsonMap(i)).toList();
      if (musics.length > 0) {
        if (Platform.isIOS) {
          musics.clear();
          musics.add(data.map((i) => Song.fromJsonMap(i)).toList()[0]);
        }
      }

      setState(() {
        musicAlbum[s] = musics;
      });
    }).catchError((e) {
      // showError(context, BmobError.convert(e).error);
    });
  }

//获取音乐列表
  Widget getMusicListItem(String s) {
    if (musicAlbum.containsKey(s)) {
      List<Song> musics = musicAlbum[s];

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
                  });
                  position = new Duration(seconds: 0);

                  SongModel songModel = Provider.of(context);
                  DownloadModel downloadModel = Provider.of(context);
                  downloadModel.setDownloads(musics);
                  songModel.setSongs(new List<Song>.from(
                      downloadModel.downloadSong));
                  songModel.setCurrentIndex(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayPage(nowPlay: true,),
                    ),
                  );
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

// 根据 downloadUrl 和 savePath 下载文件
  void downloadFile(downloadUrl) async {
    print("进入下载文件 $savePath");
    if (!Directory(savePath).existsSync()) {
      print("savePath 不存在");
      return;
    }
    // 获取存储路径
    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: savePath,
      showNotification: false,
      // show download progress in status bar (for Android)
      openFileFromNotification: true,
    );
  }

  double getIntFromMusicTime(String mTime) {
    double re = 0.1;
    try {
      if (null == mTime ||
          mTime.isEmpty ||
          mTime.endsWith("null") ||
          mTime.length < 7) {
        return 1.0;
      }
      re = double.parse(mTime.substring(0, 1)) * 60 * 60 +
          int.parse(mTime.substring(2, 4)) * 60 +
          int.parse(mTime.substring(5, 7));
    } catch (e) {
      print("解析时间出错 $mTime");
      duration = new Duration(seconds: 0);
    }
    if (mTime.startsWith("-")) {
      return 100.0;
    } else {
      return re == 0.0 ? 0.1 : re;
    }
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

  var savePath;

  Future<void> initDownLoader() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );
    savePath = (await PhoneInfo.findLocalPath(context));
    print("保存地址 :$savePath");
  }
}
