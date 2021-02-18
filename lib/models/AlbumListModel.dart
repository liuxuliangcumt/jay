import 'dart:math';

import 'package:jay/beans/Albums.dart';
import 'package:jay/logic/AlbumListLogic.dart';
import 'package:jay/logic/LBallViewLogic.dart';
import 'package:jay/widget/xball_view.dart';

import 'BaseModle.dart';
import 'SongModel.dart';

class AlbumListModel extends BaseModel {
  AlbumListLogic logic;
  LBallViewLogic ballLogic;
  List<Albums> albums;
  bool _isBall;

  List<Song> songs = new List();

  AlbumListModel() {
    logic = AlbumListLogic(this);
    ballLogic = LBallViewLogic(this);
    albums = new List();
    logic.getAlbumList();
    _isBall = false;
  }

  bool get isBall => _isBall;

  void setBall(bool v) {
    _isBall = v;
    refresh();
  }

}
