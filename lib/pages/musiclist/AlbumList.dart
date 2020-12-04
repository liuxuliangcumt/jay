import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:jay/models/AlbumListModel.dart';
import 'package:provider/provider.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    AlbumListModel model = Provider.of(context);

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
                  return Text(
                    model.songs[index].mName,
                    style: TextStyle(color: Colors.black),
                  );
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
}
