import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jay/models/SongModel.dart';
import 'package:jay/pages/LrcPage.dart';
import 'package:jay/pages/PlayPage.dart';
import 'package:provider/provider.dart';

class PlayPageHome extends StatefulWidget {
  @override
  _PlayPageHomeState createState() => _PlayPageHomeState();
}

class _PlayPageHomeState extends State<PlayPageHome>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SongModel model = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        backgroundColor: Colors.blue[200],
        elevation: 0,
        title: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          indicatorColor: Colors.grey,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(color: Colors.red, fontSize: 20),
          unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 18),
          tabs: [Tab(child: Text('歌曲')), Tab(child: Text('歌词'))],
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.animateTo(index);
        },
        children: [
          PlayPage(
            nowPlay: true,
          ),
          LrcPage(model)
        ],
      ),
    );
  }
}
