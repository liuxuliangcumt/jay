import 'package:flutter/cupertino.dart';
import 'package:jay/pages/musiclist/AlbumList.dart';
import 'package:jay/pages/musiclist/FavoriteList.dart';
import 'package:jay/pages/musiclist/MusicList.dart';


class HomePageModel extends ChangeNotifier {
  int _currentIndex = 0;
  var pageController = PageController();

  int get currentIndex => _currentIndex;
  List<Widget> pages = [
    AlbumList(),
    Text('text'),
    FavoriteList(),
    MusicList()
  ];

  void setCurrentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}
