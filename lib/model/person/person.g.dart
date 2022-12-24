// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Person _$$_PersonFromJson(Map<String, dynamic> json) => _$_Person(
      id: json['id'] as int,
      name: json['name'] as String,
      age: json['age'] as int?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      email: json['email'] as String?,
      memo: json['memo'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      updated: DateTime.parse(json['updated'] as String),
      created: DateTime.parse(json['created'] as String),
    );

Map<String, dynamic> _$$_PersonToJson(_$_Person instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'birthday': instance.birthday?.toIso8601String(),
      'email': instance.email,
      'memo': instance.memo,
      'tags': instance.tags,
      'updated': instance.updated.toIso8601String(),
      'created': instance.created.toIso8601String(),
    };
