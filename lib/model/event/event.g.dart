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
      updated: const UpdatedConverter().fromJson(json['updated']),
      created: const CreatedConverter().fromJson(json['created']),
    );

Map<String, dynamic> _$$_EventToJson(_$_Event instance) => <String, dynamic>{
      'id': instance.id,
      'dateTime': instance.dateTime.toIso8601String(),
      'text': instance.text,
      'personIdList': instance.personIdList,
      'tags': instance.tags,
      'updated': const UpdatedConverter().toJson(instance.updated),
      'created': const CreatedConverter().toJson(instance.created),
    };
