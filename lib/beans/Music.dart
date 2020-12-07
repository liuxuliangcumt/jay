import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Music.g.dart';

@JsonSerializable()
class jayMusic extends BmobObject {
  String mName;
  String urlPath;
  String album;
  String picUrl;

  jayMusic();

  factory jayMusic.fromJson(Map<String, dynamic> json) => _$MusicFromJson(json);

  Map<String, dynamic> toJson() => _$MusicToJson(this);

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
