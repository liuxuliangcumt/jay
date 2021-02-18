import 'dart:math';

import 'package:jay/models/AlbumListModel.dart';
import 'package:jay/models/SongModel.dart';
import 'package:jay/widget/lball_view.dart';

class LBallViewLogic {
  AlbumListModel _model;

  LBallViewLogic(this._model);

  List<Point> points = [];

  void generatePoints(List<Song> songs) {
    points.clear();
    Random random = Random();
    //仰角基准值
    //均匀分布仰角
    List<double> centers = [
      0.5,
      0.35,
      0.65,
      0.35,
      0.2,
      0.5,
      0.65,
      0.35,
      0.65,
      0.8,
    ];

    //将2pi分为keywords.length等份
    double dAngleStep = 2 * pi / songs.length;
    for (int i = 0; i < songs.length; i++) {
      //极坐标方位角
      double dAngle = dAngleStep * i;
      //仰角
      double eAngle = (centers[i % 10] + (random.nextDouble() - 0.5) / 10) * pi;

      //球极坐标转为直角坐标
      double x = radius * sin(eAngle) * sin(dAngle);
      double y = radius * cos(eAngle);
      double z = radius * sin(eAngle) * cos(dAngle);

      Point point = Point(x, y, z);
      point.name = songs[i].mName;
      print("初始化 名字： ${point.name}");
      //  bool needHight = _needHight(point.name);
      bool needHight = false;

      //计算point在各个z坐标时的paragraph
      point.paragraphs = [];
      //每3个z生成一个paragraphs，节省内存
      for (int z = -radius; z <= radius; z += 3) {
        point.paragraphs.add(
          buildText(
            point.name,
            2.0 * radius,
            getFontSize(z.toDouble()),
            getFontOpacity(z.toDouble()),
            needHight,
          ),
        );
      }
      points.add(point);
    }
    _model.refresh();
  }
}
