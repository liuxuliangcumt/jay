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
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        leading: Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Container(
          width: 150,
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            controller: _tabController,
            indicatorColor: Colors.grey,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[200],
            labelStyle: TextStyle(color: Colors.red, fontSize: 14),
            unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 12),
            tabs: [Tab(child: Text('歌曲')), Tab(child: Text('歌词'))],
          ),
        ),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        physics: BouncingScrollPhysics(),
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
