import 'package:jay/beans/Albums.dart';
import 'package:jay/logic/AlbumListLogic.dart';

import 'BaseModle.dart';
import 'SongModel.dart';

class AlbumListModel extends BaseModel {
  AlbumListLogic logic;
  List<Albums> albums;

  List<Song> songs = new List();

  AlbumListModel() {
    logic = AlbumListLogic(this);
    logic.getAlbumList();
    albums = new List();
  }
}
