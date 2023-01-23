import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:person_note/util/converter.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required DateTime dateTime,
    required String text,
    List<String>? personIdList,
    List<String>? tags,
    @UpdatedConverter() DateTime? updated,
    @CreatedConverter() DateTime? created,
  }) = _Event;

  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
}
