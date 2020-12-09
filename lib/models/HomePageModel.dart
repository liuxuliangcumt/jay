import 'package:flutter/cupertino.dart';
import 'package:jay/pages/musiclist/AlbumList.dart';
import 'package:jay/pages/musiclist/DownloadList.dart';
import 'package:jay/pages/musiclist/FavoriteList.dart';

class HomePageModel extends ChangeNotifier {
  int _currentIndex = 0;
  var pageController = PageController();

  int get currentIndex => _currentIndex;
  List<Widget> pages = [
    AlbumList(),
    DownloadList(),
    FavoriteList(),
    Text('text'),
  ];

  void setCurrentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}
