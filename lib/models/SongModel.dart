import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class SongModel with ChangeNotifier {
  String _url;

  String get url => _url;

  setUrl(String url) {
    _url = url;
    notifyListeners();
  }

  SongModel() {
    _audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    audioCache1 = new AudioCache(fixedPlayer: _audioPlayer);
  }

  AudioCache audioCache1;

  AudioPlayer _audioPlayer;

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

  setCurrentIndex(int index) {
    _currentSongIndex = index;
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
}

class Song {
  String type;
  String link;
  int songid;
  String mName;
  String author = "";
  String lrc;
  String urlPath;
  String pic;
  String objectId;

  Song.fromJsonMap(Map<String, dynamic> map)
      : type = map["type"],
        link = map["link"],
        songid = map["songid"],
        mName = map["mName"],
        author = map["author"],
        lrc = map["lrc"],
        urlPath = map["urlPath"],
        objectId = map["objectId"],
        pic = map["pic"];

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
    data['pic'] = pic;
    return data;
  }
}
