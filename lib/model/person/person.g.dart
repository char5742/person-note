// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Person _$$_PersonFromJson(Map<String, dynamic> json) => _$_Person(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      email: json['email'] as String?,
      memo: json['memo'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      updated: const UpdatedConverter().fromJson(json['updated']),
      created: const CreatedConverter().fromJson(json['created']),
    );

Map<String, dynamic> _$$_PersonToJson(_$_Person instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'birthday': instance.birthday?.toIso8601String(),
      'email': instance.email,
      'memo': instance.memo,
      'tags': instance.tags,
      'updated': const UpdatedConverter().toJson(instance.updated),
      'created': const CreatedConverter().toJson(instance.created),
    };
