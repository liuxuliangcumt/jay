import 'package:flutter/foundation.dart';

class LrcItemBean {
  String lrcTime;
  String lineContent;

  Duration duration;

  LrcItemBean(this.lrcTime, this.lineContent) {
    if (lrcTime.contains(".")) {
      setDuration(lrcTime);
    } else {
      duration = Duration();
    }
  }

  void setDuration(String lrcTime) {
    duration = Duration(
        seconds: int.parse(lrcTime.substring(3, 5)),
        minutes: int.parse(lrcTime.substring(0, 2)),
        milliseconds: int.parse(lrcTime.substring(6)) * 10);
  }
}
