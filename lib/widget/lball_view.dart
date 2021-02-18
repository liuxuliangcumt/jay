import 'dart:collection';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jay/models/AlbumListModel.dart';
import 'dart:ui' as ui;

import 'package:jay/models/SongModel.dart';
import 'package:provider/provider.dart';

//手指按下时命中的point
PointAnimationSequence pointAnimationSequence;

//球半径
int radius = 150;

class LBallView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AlbumListModel model = Provider.of(context);
    /*   widget.keywords = model.songs;
    widget.highlight = [model.songs.first];
    widget.points = model.points;*/
    model.ballLogic.generatePoints(model.songs);
    //带光晕的球图片宽度
    double sizeOfBallWithFlare;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4079A7),
              Color(0xFF27507F),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                "images/symptom_light@3x.png",
                width: 260,
                height: 260,
                fit: BoxFit.fill,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Image.asset(
                      "images/symptom_ballwithflare@3x.png",
                      width: sizeOfBallWithFlare,
                      height: sizeOfBallWithFlare,
                      fit: BoxFit.fill,
                    ),
                    // _buildBall(),
                  ],
                ),
                Image.asset(
                  "images/symptom_ball_shadow@3x.png",
                  width: 260,
                  height: 20,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBall() {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        int now = DateTime.now().millisecondsSinceEpoch;
        downPosition = convertCoordinate(event.localPosition);
        lastPosition = convertCoordinate(event.localPosition);

        //速度跟踪队列
        clearQueue();
        addToQueue(PositionWithTime(downPosition, now));

        //手指触摸时停止动画
        controller.stop();
      },
      onPointerMove: (PointerMoveEvent event) {
        int now = DateTime.now().millisecondsSinceEpoch;
        Offset currentPostion = convertCoordinate(event.localPosition);

        addToQueue(PositionWithTime(currentPostion, now));

        Offset delta = Offset(currentPostion.dx - lastPosition.dx, currentPostion.dy - lastPosition.dy);
        double distance = sqrt(delta.dx * delta.dx + delta.dy * delta.dy);
        //若计算量级太小，框架内部会报精度溢出的错误
        if (distance > 2) {
          //旋转点
          /*  setState(() {
            lastPosition = currentPostion;
            //球体应该旋转的弧度角度 = 距离/radius
            double radian = distance / radius;
            //旋转轴
            axisVector = getAxisVector(delta);
            //更新点的位置
            for (int i = 0; i < points.length; i++) {
              rotatePoint(axisVector, points[i], radian);
            }
          });*/
        }
      },
      onPointerUp: (PointerUpEvent event) {
        int now = DateTime.now().millisecondsSinceEpoch;
        Offset upPosition = convertCoordinate(event.localPosition);

        addToQueue(PositionWithTime(upPosition, now));

        //检测是否是fling手势
        Offset velocity = getVelocity();
        //速度模量>=1就认为是fling手势
        if (sqrt(velocity.dx * velocity.dx + velocity.dy * velocity.dy) >= 1) {
          //开始fling动画
          currentRadian = 0;
          controller.fling();
        } else {
          //开始匀速动画
          currentRadian = 0;
          controller.forward(from: 0.0);
        }

        //检测点击事件
        double distanceSinceDown = sqrt(pow(upPosition.dx - downPosition.dx, 2) + pow(upPosition.dy - downPosition.dy, 2));
        //按下和抬起点的距离小于4，认为是点击事件
        /*  if (distanceSinceDown < 4) {
          //寻找命中的point
          int searchRadiusW = 30;
          int searchRadiusH = 10;
          for (int i = 0; i < points.length; i++) {
            //points[i].z >= 0：只在球正面的点中寻找
            if (points[i].z >= 0 && (upPosition.dx - points[i].x).abs() < searchRadiusW && (upPosition.dy - points[i].y).abs() < searchRadiusH) {
              int now = DateTime.now().millisecondsSinceEpoch;
              //防止双击
              if (now - lastHitTime > 2000) {
                lastHitTime = now;

                //创建点选中动画序列
                pointAnimationSequence = PointAnimationSequence(points[i], _needHight(points[i].name));

                //跳转页面
                Future.delayed(Duration(milliseconds: 500), () {
                  print("点击“${points[i].name}”");
                });
              }
              break;
            }
          }
        }*/
      },
      onPointerCancel: (_) {
        //开始匀速动画
        currentRadian = 0;
        controller.forward(from: 0.0);
      },
      child: ClipOval(
        child: CustomPaint(
          size: Size(2.0 * radius, 2.0 * radius),
          painter: MyPainter(widget.points),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  List<Point> points;
  Paint ballPaint, pointPaint;

  MyPainter(this.points) {
    ballPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //绘制球
    //canvas.drawCircle(Offset(radius, radius), radius, ballPaint);

    //绘制文字
    for (int i = 0; i < points.length; i++) {
      List<double> xy = transformCoordinate(points[i]);

      ui.Paragraph p;
      //是被选中的点，需要展示放大缩小效果
      if (pointAnimationSequence != null && pointAnimationSequence.point == points[i]) {
        //动画未播放完毕
        if (pointAnimationSequence.paragraphs.isNotEmpty) {
          p = pointAnimationSequence.paragraphs.removeFirst();
          //动画已播放完毕
        } else {
          p = points[i].getParagraph(radius);
          pointAnimationSequence = null;
        }
      } else {
        p = points[i].getParagraph(radius);
      }

      //获得文字的宽高
      double halfWidth = p.minIntrinsicWidth / 2;
      double halfHeight = p.height / 2;
      //绘制文字（point中是3d模型坐标系中的坐标，需要转换为绘图坐标系中的坐标）
      canvas.drawParagraph(
        p,
        Offset(xy[0] - halfWidth, xy[1] - halfHeight),
      );
    }
  }

  ///将3d模型坐标系中的坐标转换为绘图坐标系中的坐标
  ///x2 = r+x1;y2 = r-y1;
  List<double> transformCoordinate(Point point) {
    return [radius + point.x, radius - point.y, point.z];
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

///计算点point绕轴axis旋转radian弧度后的点坐标
///计算依据：罗德里格旋转矢量公式
void rotatePoint(
  Point axis,
  Point point,
  double radian,
) {
  double x = cos(radian) * point.x +
      (1 - cos(radian)) * (axis.x * point.x + axis.y * point.y + axis.z * point.z) * axis.x +
      sin(radian) * (axis.y * point.z - axis.z * point.y);

  double y = cos(radian) * point.y +
      (1 - cos(radian)) * (axis.x * point.x + axis.y * point.y + axis.z * point.z) * axis.y +
      sin(radian) * (axis.z * point.x - axis.x * point.z);

  double z = cos(radian) * point.z +
      (1 - cos(radian)) * (axis.x * point.x + axis.y * point.y + axis.z * point.z) * axis.z +
      sin(radian) * (axis.x * point.y - axis.y * point.x);

  point.x = x;
  point.y = y;
  point.z = z;
}

///根据手指触摸移动的直线距离，计算球体应该转动的近似角度
///单位角度对应的圆弧长度：2*pi*r/2*pi = 1/r
double getRadian(double distance) {
  return distance / radius;
}

//将绘图坐标系中的坐标转换为3d模型坐标系中的坐标
Offset convertCoordinate(Offset offset) {
  return Offset(offset.dx - radius, radius - offset.dy);
}

///由旋转矢量得到旋转轴方向的单位矢量
///将旋转矢量(x,y)逆时针旋转90度即可
///x2 = xcos(pi/2)-ysin(pi/2)
///y2 = xsin(pi/2)+ycos(pi/2)
Point getAxisVector(Offset scrollVector) {
  double x = -scrollVector.dy;
  double y = scrollVector.dx;
  double module = sqrt(x * x + y * y);
  return Point(x / module, y / module, 0);
}

ui.Paragraph buildText(
  String content,
  double maxWidth,
  double fontSize,
  double opacity,
  bool highLight,
) {
  String text = content;
  //一行5个文字，最多两行，末尾显示...
  if (content.length > 5) {
    String firstLine = text.substring(0, 5);
    String secondLine = text.substring(5);
    if (secondLine.length > 5) {
      secondLine = secondLine.substring(0, 4) + "...";
    }
    text = "$firstLine\n$secondLine";
  }

  ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle());
  paragraphBuilder.pushStyle(
    ui.TextStyle(
        fontSize: fontSize,
        color: highLight ? Colors.white.withOpacity(opacity) : Color(0xFFC1E0FF).withOpacity(opacity),
        height: 1.0,
        shadows: highLight
            ? [
                Shadow(
                  color: Colors.white.withOpacity(opacity),
                  offset: Offset(0, 0),
                  blurRadius: 10,
                )
              ]
            : []),
  );
  paragraphBuilder.addText(text);

  ui.Paragraph paragraph = paragraphBuilder.build();
  paragraph.layout(ui.ParagraphConstraints(width: maxWidth));
  return paragraph;
}

double getFontSize(double z) {
  //点的z坐标为[-r,r]，对应文字的尺寸为[8,16]
  return 8 + 8 * (z + radius) / (2 * radius);
}

double getFontOpacity(double z) {
  //点的z坐标为[-r,r]，对应点的透明度为[0.5,1]
  return 0.5 + 0.5 * (z + radius) / (2 * radius);
}

class Point {
  double x, y, z;
  String name;
  List<ui.Paragraph> paragraphs;

  Point(this.x, this.y, this.z);

  //z取值[-radius,radius]时的paragraph，依次存储在paragraphs中
  //每3个z生成一个paragraphs
  getParagraph(int radius) {
    int index = (z + radius).round() ~/ 3;
    return paragraphs[index];
  }
}

class PositionWithTime {
  Offset position;
  int time;

  PositionWithTime(this.position, this.time);
}

class PointAnimationSequence {
  Point point;
  bool needHighLight;
  Queue<ui.Paragraph> paragraphs;

  PointAnimationSequence(this.point, this.needHighLight) {
    paragraphs = Queue();

    double fontSize = getFontSize(point.z);
    double opacity = getFontOpacity(point.z);
    //字号从fontSize变化到22
    for (double fs = fontSize; fs <= 22; fs += 1) {
      paragraphs.addLast(buildText(point.name, 2.0 * radius, fs, opacity, needHighLight));
    }
    //字号从22变化到fontSize
    for (double fs = 22; fs >= fontSize; fs -= 1) {
      paragraphs.addLast(buildText(point.name, 2.0 * radius, fs, opacity, needHighLight));
    }
  }
}
