import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:person_note/utils/converter.dart';

part 'person_model.freezed.dart';
part 'person_model.g.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required String id,
    required String name,
    int? age,
    DateTime? birthday,
    String? email,
    required String memo,
    List<String>? tags,
    @UpdatedConverter() DateTime? updated,
    @CreatedConverter() DateTime? created,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
}
