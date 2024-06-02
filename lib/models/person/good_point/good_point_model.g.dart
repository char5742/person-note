// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'good_point_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoodPointImpl _$$GoodPointImplFromJson(Map<String, dynamic> json) =>
    _$GoodPointImpl(
      id: json['id'] as String,
      point: json['point'] as String,
      updated: const UpdatedConverter().fromJson(json['updated']),
      created: const CreatedConverter().fromJson(json['created']),
    );

Map<String, dynamic> _$$GoodPointImplToJson(_$GoodPointImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'point': instance.point,
      'updated': const UpdatedConverter().toJson(instance.updated),
      'created': const CreatedConverter().toJson(instance.created),
    };
