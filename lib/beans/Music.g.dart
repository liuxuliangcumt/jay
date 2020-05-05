// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

jayMusic _$MusicFromJson(Map<String, dynamic> json) {
  return jayMusic()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..ACL = json['ACL'] as Map<String, dynamic>
    ..mName = json['mName'] as String
    ..urlPath = json['urlPath'] as String
    ..album = json['album'] as String;
}

Map<String, dynamic> _$MusicToJson(jayMusic instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'mName': instance.mName,
      'urlPath': instance.urlPath,
      'album': instance.album
    };
