import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:person_note/util/converter.dart';

part 'person.freezed.dart';
part 'person.g.dart';

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
