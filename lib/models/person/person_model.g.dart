// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PersonImpl _$$PersonImplFromJson(Map<String, dynamic> json) => _$PersonImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num?)?.toInt(),
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      email: json['email'] as String?,
      memo: json['memo'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      updated: const UpdatedConverter().fromJson(json['updated']),
      created: const CreatedConverter().fromJson(json['created']),
    );

Map<String, dynamic> _$$PersonImplToJson(_$PersonImpl instance) =>
    <String, dynamic>{
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
