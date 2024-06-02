import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:person_note/utils/converter.dart';

part 'good_point_model.freezed.dart';
part 'good_point_model.g.dart';

@freezed
class GoodPoint with _$GoodPoint {
  const factory GoodPoint({
    required String id,
    required String point,
    @UpdatedConverter() DateTime? updated,
    @CreatedConverter() DateTime? created,
  }) = _GoodPoint;

  factory GoodPoint.fromJson(Map<String, Object?> json) =>
      _$GoodPointFromJson(json);
}
