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
        color: Colors.grey,
        child: PageView.builder(
          itemBuilder: (ctx, index) => model.pages[index],
          itemCount: model.pages.length,
          controller: model.pageController,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.black, fontSize: 15),
        unselectedLabelStyle: TextStyle(color: Colors.grey, fontSize: 13),
        showUnselectedLabels: true,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: '搜索'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '下载'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '下载'),
        ],
        currentIndex: model.currentIndex,
        onTap: (vule) {
          model.setCurrentIndex(vule);
          model.pageController.jumpToPage(vule);
        },
      ),
    );
  }
}
