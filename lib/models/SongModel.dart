import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:jay/beans/LrcItemBean.dart';

class SongModel with ChangeNotifier {
  String _url;

  String get url => _url;
  int currentLrc;

  setCurrentLrc(int c) {
    currentLrc = c;
    notifyListeners();
  }

  setUrl(String url) {
    _url = url;
    notifyListeners();
  }

  SongModel() {
    // _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    audioCache1 = new AudioCache(fixedPlayer: _audioPlayer);
    loadLrc();
  }

  AudioCache audioCache1;

  AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  List<Song> _songs = [];

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  setPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  bool _isRepeat = true;

  bool get isRepeat => _isRepeat;

  changeRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }

  bool _showList = false;

  bool get showList => _showList;

  setShowList(bool showList) {
    _showList = showList;
    notifyListeners();
  }

  int _currentSongIndex = 0;

  List<Song> get songs => _songs;

  setSongs(List<Song> songs) {
    _songs = songs;
    notifyListeners();
  }

  addSongs(List<Song> songs) {
    _songs.addAll(songs);
    notifyListeners();
  }

  int get length => _songs.length;

  int get songNumber => _currentSongIndex + 1;

  setCurrentIndexAdd() {
    _currentSongIndex++;
    notifyListeners();
  }

  /// 在播放列表界面点击后立刻播放
  bool _playNow = false;

  bool get playNow => _playNow;

  setPlayNow(bool playNow) {
    _playNow = playNow;
    notifyListeners();
  }

  // Song get currentSong => _songs[_currentSongIndex];
  Song get currentSong {
    if (_songs.length != 0) {
      return _songs[_currentSongIndex];
    } else {
      return null;
    }
  }

  Song get nextSong {
    if (isRepeat) {
      if (_currentSongIndex < length) {
        _currentSongIndex++;
      }
      if (_currentSongIndex == length) {
        _currentSongIndex = 0;
      }
    } else {
      Random r = new Random();
      _currentSongIndex = r.nextInt(_songs.length);
    }
    notifyListeners();
    return _songs[_currentSongIndex];
  }

  Song get prevSong {
    if (isRepeat) {
      if (_currentSongIndex > 0) {
        _currentSongIndex--;
      }
      if (_currentSongIndex == 0) {
        _currentSongIndex = length - 1;
      }
    } else {
      Random r = new Random();
      _currentSongIndex = r.nextInt(_songs.length);
    }
    notifyListeners();
    return _songs[_currentSongIndex];
  }

  Duration _position;

  Duration get position => _position;

  void setPosition(Duration position) {
    _position = position;
    notifyListeners();
  }

  Duration _duration;

  Duration get duration => _duration;

  void setDuration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  String songLrc;
  List<LrcItemBean> lrcItemBeans = new List();

  loadLrc() async {
    //  http://www.9ku.com/downlrc.php?id=91161

    final bytes = await readBytes("http://www.9ku.com/downlrc.php?id=91161");
    Utf8Decoder utf8decoder = new Utf8Decoder();
    String lrc = utf8decoder.convert(bytes);

    songLrc = lrc;
    List<String> lrcs = songLrc.split("[");
    lrcItemBeans.clear();
    for (int i = 0; i < lrcs.length; i++) {
      List<String> item = lrcs[i].split(']');
      debugPrint(lrcs[i]);
      if (item.length == 2) {
        lrcItemBeans.add(LrcItemBean(item[0].trim(), item[1].trim()));
      }
    }
    debugPrint(lrcItemBeans.length.toString() + " 歌词个数、 ");
    notifyListeners();
  }
}

class Song extends Iterable {
  String type = "";
  String link = "";
  int songid = 0;
  String mName = "";
  String author = "";
  String lrc = "";
  String urlPath = "";
  String picUrl = "";
  String objectId = "";
  bool isLoading = false;

  Song.fromJsonMap(Map<String, dynamic> map)
      : type = map["type"],
        link = map["link"],
        songid = map["songid"],
        mName = map["mName"],
        author = map["author"],
        lrc = map["lrc"],
        urlPath = map["urlPath"],
        objectId = map["objectId"],
        isLoading = false,
        picUrl = map["picUrl"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = type;
    data['link'] = link;
    data['songid'] = songid;
    data['mName'] = mName;
    data['author'] = author;
    data['lrc'] = lrc;
    data['objectId'] = objectId;
    data['urlPath'] = urlPath;
    data['isLoading'] = false;
    data['picUrl'] = picUrl;
    return data;
  }

  @override
  String toString() {
    return 'Song{type: $type, link: $link, songid: $songid, mName: $mName, author: $author, lrc: $lrc, urlPath: $urlPath, picUrl: $picUrl, objectId: $objectId, isLoading: $isLoading}';
  }

  @override
  // TODO: implement iterator
  Iterator get iterator => throw UnimplementedError();
}
