import 'package:flutter/cupertino.dart';
import 'package:jay/models/BaseModle.dart';
import 'package:jay/models/SongModel.dart';
import 'package:localstorage/localstorage.dart';

const String kLocalStorageSearch = 'kLocalStorageSearch';
const String kFavoriteList = 'kFavoriteList';

class FavoriteModel extends BaseModel {
  List<Song> favoriteSongs = List();

  FavoriteModel() {
    loadData();
  }

  @override
  Future<List<Song>> loadData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    List<Song> favoriteList =
        (localStorage.getItem(kFavoriteList) ?? []).map<Song>((item) {
      return Song.fromJsonMap(item);
    }).toList();
    setFavorites(favoriteList);
    // setIdle();
    return favoriteList;
  }

  setFavorites(List<Song> favoriteSong) {
    favoriteSongs = favoriteSong;
    notifyListeners();
  }

  collect(Song song) {
    /*   favoriteSongs.removeWhere((element) {
      return element.objectId == song.objectId;
    });*/

    if (favoriteSongs.contains(song)) {
      favoriteSongs.remove(song);
    } else {
      favoriteSongs.add(song);
    }
    saveData();
    refresh();
  }

  isCollect(Song song) {
    bool isCollect = false;
    for (int i = 0; i < favoriteSongs.length; i++) {
      if (favoriteSongs[i].objectId == song.objectId) {
        isCollect = true;
        break;
      }
    }
    return isCollect;
  }

  void saveData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
    await localStorage.ready;
    localStorage.setItem(kFavoriteList, favoriteSongs);
  }
}
