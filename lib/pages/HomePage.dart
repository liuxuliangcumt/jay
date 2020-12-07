import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jay/models/HomePageModel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    HomePageModel model = Provider.of(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: PageView.builder(
          itemBuilder: (ctx, index) => model.pages[index],
          itemCount: model.pages.length,
          controller: model.pageController,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          //指定为fixed就解决了。
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: TextStyle(color: Colors.black, fontSize: 15),
          unselectedLabelStyle: TextStyle(color: Colors.grey, fontSize: 13),
          showUnselectedLabels: true,
          selectedIconTheme: IconThemeData(size: 30),
          unselectedIconTheme: IconThemeData(size: 25),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[200],
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
            BottomNavigationBarItem(icon: Icon(Icons.music_note), label: '下载'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
          ],
          currentIndex: model.currentIndex,
          onTap: (vule) {
            model.setCurrentIndex(vule);
            model.pageController.jumpToPage(vule);
          },
        ),
      ),
    );
  }
}
