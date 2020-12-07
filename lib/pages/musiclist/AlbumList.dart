import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jay/models/AlbumListModel.dart';
import 'package:jay/models/SongModel.dart';
import 'package:jay/widget/Player.dart';
import 'package:provider/provider.dart';

import '../PlayPage.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    AlbumListModel model = Provider.of(context);
    SongModel songModel = Provider.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.albums.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Container(
                              child: Image.network(
                                model.albums[index].picUrl.trim(),
                                fit: BoxFit.fill,
                              ),
                              height: 200,
                              width: 200,
                            ),
                            onTap: () {
                              model.logic
                                  .getMusicList(model.albums[index].name);
                            },
                          ),
                          Text(
                            model.albums[index].name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              ListView.builder(
                itemCount: model.songs.length,
                shrinkWrap: true, //解决无限高度问题
                physics: new NeverScrollableScrollPhysics(),
                itemBuilder: (c, index) {
                  return buildItem(index, model,songModel);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget buildItem(int index, AlbumListModel model, SongModel songModel) {
    Song song =model.songs[index];
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
      child: Row(
        children: [
          InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                height: 50,
                width: 50,
                child: Image.network(song.picUrl, fit: BoxFit.cover),
              ),
            ),
            onTap: () {
              debugPrint(song.toString());

              songModel.setSongs(model.songs);
              songModel.setCurrentIndex(index);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayPage(
                    nowPlay: true,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 10),
          Text(
            song.mName,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          Expanded(
            child: Container(),
          ),
          Icon(
            Icons.favorite_border,
            size: 20,
          ),
          SizedBox(width: 20)
        ],
      ),
    );
    return Text(
      song.mName,
      style: TextStyle(color: Colors.black),
    );
  }
}
