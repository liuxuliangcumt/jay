import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_banner_swiper/flutter_banner_swiper.dart';
import 'package:jay/models/MusicListModel.dart';
import 'package:provider/provider.dart';

import 'AlbumList.dart';

class JayMusicList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MusicListModel model = Provider.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
             /* BannerSwiper(
                //width  和 height 是图片的高宽比  不用传具体的高宽   必传
                height: 108,
                width: 54,
                length: model.bannerList.length,
                getwidget: (index) {
                  return new GestureDetector(
                      child: Image.network(
                        model.bannerList[index % model.bannerList.length],
                        fit: BoxFit.cover,
                      ),
                      onTap: () {});
                },
              ),*/


            ],
          ),
        ),
      ),
    );
  }
}
