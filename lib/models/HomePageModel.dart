import 'package:flutter/cupertino.dart';
import 'package:jay/pages/musiclist/AlbumList.dart';
import 'package:jay/pages/musiclist/JayMusicList.dart';

class HomePageModel extends ChangeNotifier {
  int _currentIndex = 0;
  var pageController = PageController();

  int get currentIndex => _currentIndex;
  List<Widget> pages = [
    AlbumList(),
    Text('text'),
    Text('text'),
    Text('text1')
  ];

  void setCurrentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }
}
