import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:flutter/cupertino.dart';
import 'package:jay/beans/Albums.dart';
import 'package:jay/beans/Music.dart';
import 'package:jay/models/AlbumListModel.dart';
import 'package:jay/models/SongModel.dart';

class AlbumListLogic {
  AlbumListModel _model;

  AlbumListLogic(this._model);

  getAlbumList() {
    List<Albums> albums = new List();
    BmobQuery<Albums> query = BmobQuery();
    query.queryObjects().then((data) {
      albums = data.map((i) => Albums.fromJson(i)).toList();
      _model.albums.clear();
      _model.albums.addAll(albums);
      _model.refresh();
      debugPrint(data.toString());
    }).catchError((e) {
      debugPrint("专辑列表获取失败");

      // showError(context, BmobError.convert(e).error);
    });
  }

  getMusicList(String albumName) {
    List<Song> musics = new List();
    BmobQuery<jayMusic> query = BmobQuery();
    query.addWhereEqualTo("album", albumName);
    query.queryObjects().then((data) {
      musics = data.map((i) => Song.fromJsonMap(i)).toList();
      _model.songs.clear();
      _model.songs.addAll(musics);
      _model.refresh();
    }).catchError((e) {
      // showError(context, BmobError.convert(e).error);
    });
  }
}
