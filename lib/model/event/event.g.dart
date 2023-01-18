// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Event _$$_EventFromJson(Map<String, dynamic> json) => _$_Event(
      id: json['id'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      text: json['text'] as String,
      personIdList: (json['personIdList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      updated: DateTime.parse(json['updated'] as String),
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$$_EventToJson(_$_Event instance) => <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime.toIso8601String(),
      'text': instance.text,
      'personIdList': instance.personIdList,
      'tags': instance.tags,
      'updated': instance.updated.toIso8601String(),
      'created': instance.created.toIso8601String(),
    };
