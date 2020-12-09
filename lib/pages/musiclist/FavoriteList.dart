import 'package:flutter/material.dart';
import 'package:jay/models/FavoriteModel.dart';
import 'package:jay/models/SongModel.dart';
import 'package:provider/provider.dart';

class FavoriteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FavoriteModel model = Provider.of(context);

    return Container(
      child: ListView.builder(
        itemCount: model.favoriteSongs.length,
        itemBuilder: (ct, index) {
          Song song = model.favoriteSongs[index];
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
                  onTap: () {},
                ),
                SizedBox(width: 10),
                Text(
                  song.mName,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(
                  icon: Icon(
                    model.isCollect(song)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 20,
                    color: model.isCollect(song)
                        ? Theme.of(context).accentColor
                        : Colors.grey,
                  ),
                  onPressed: () {
                    model.collect(song);
                  },
                ),
                SizedBox(width: 20)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildItem(
      int index, FavoriteModel favoriteModel, BuildContext context) {
    Song song = favoriteModel.favoriteSongs[index];
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
            onTap: () {},
          ),
          SizedBox(width: 10),
          Text(
            song.mName,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          Expanded(
            child: Container(),
          ),
          IconButton(
            icon: Icon(
              favoriteModel.isCollect(song)
                  ? Icons.favorite
                  : Icons.favorite_border,
              size: 20,
              color: favoriteModel.isCollect(song)
                  ? Theme.of(context).accentColor
                  : Colors.grey,
            ),
            onPressed: () {
              favoriteModel.collect(song);
            },
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
