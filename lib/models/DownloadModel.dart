import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jay/config/storage_manager.dart';
import 'package:jay/models/view_state_list_model.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

import 'SongModel.dart';

const String kLocalStorageSearch = 'kLocalStorageSearch';
const String kDownloadList = 'kDownloadList';
const String kDirectoryPath = 'kDirectoryPath';

/// 我的下载列表
class DownloadListModel extends ViewStateListModel<Song> {
  DownloadModel downloadModel;

  DownloadListModel({this.downloadModel});

  @override
  Future<List<Song>> loadData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    List<Song> downloadList =
        (localStorage.getItem(kDownloadList) ?? []).map<Song>((item) {
      return Song.fromJsonMap(item);
    }).toList();
    downloadModel.setDownloads(downloadList);
    setIdle();
    return downloadList;
  }
}

class DownloadModel with ChangeNotifier {
  DownloadModel() {
    _directoryPath = StorageManager.sharedPreferences.getString(kDirectoryPath);
    loadData();
  }

  @override
  Future<List<Song>> loadData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    List<Song> downloadList =
        (localStorage.getItem(kDownloadList) ?? []).map<Song>((item) {
      return Song.fromJsonMap(item);
    }).toList();
    setDownloads(downloadList);

    return downloadList;
  }

  List<Song> _downloadSong = [];

  List<Song> get downloadSong => _downloadSong;

  setDownloads(List<Song> downloadSong) {
    _downloadSong = downloadSong;
    notifyListeners();
  }

  download(Song song) {
    if (_downloadSong.contains(song)) {
      removeFile(song);
    } else {
      downloadFile(song);
    }
  }

  String getSongUrl(Song s) {
    return 'http://music.163.com/song/media/outer/url?id=${s.songid}.mp3';
  }

  Future downloadFile(Song s) async {
    debugPrint("下载点击了  进入下载");
    s.isLoading = true;
    debugPrint(s.toString());
    final bytes = await readBytes(s.urlPath);



    final dir = await getApplicationDocumentsDirectory();
    setDirectoryPath(dir.path);
    //  final file = File('${dir.path}/${s.songid}.mp3');

    final file = File('${dir.path}/${s.objectId}.mp3');
    if (await file.exists()) {
      return;
    }

    notifyListeners();
    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      debugPrint("下载点击了  下载结束");

      s.isLoading = false;
      _downloadSong.add(s);
      debugPrint(s.toString());

      saveData();
      notifyListeners();
    }
  }

  String _directoryPath;

  String get getDirectoryPath => _directoryPath;

  setDirectoryPath(String directoryPath) {
    _directoryPath = directoryPath;
    StorageManager.sharedPreferences.setString(kDirectoryPath, _directoryPath);
  }

  Future removeFile(Song s) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${s.objectId}.mp3');
    setDirectoryPath(dir.path);
    if (await file.exists()) {
      await file.delete();
      _downloadSong.remove(s);
      saveData();
      notifyListeners();
    }
  }

  saveData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    localStorage.setItem(kDownloadList, _downloadSong);
  }

  isDownload(Song newSong) {
    bool isDownload = false;
    for (int i = 0; i < _downloadSong.length; i++) {
      if (_downloadSong[i].objectId == newSong.objectId) {
        isDownload = true;
        break;
      }
    }
    return isDownload;
  }
}
