import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

class Albums extends BmobObject {
  String name;
  String picUrl;
  String issueTime;

  Albums({this.name, this.picUrl, this.issueTime});

  Albums.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    picUrl = json['picUrl'];
    issueTime = json['issueTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['picUrl'] = this.picUrl;
    data['issueTime'] = this.issueTime;
    return data;
  }

  @override
  Map getParams() {
    Map<String, dynamic> map = toJson();
    Map<String, dynamic> data = new Map();
    //去除空值
    map.forEach((key, value) {
      if (value != null) {
        data[key] = value;
      }
    });
    return map;
  }
}
