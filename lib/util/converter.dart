import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class CreatedConverter implements JsonConverter<DateTime?, Object?> {
  const CreatedConverter();

  @override
  DateTime? fromJson(Object? timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  @override
  Object? toJson(DateTime? date) =>
      date == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(date);
}

class UpdatedConverter implements JsonConverter<DateTime?, Object?> {
  const UpdatedConverter();

  @override
  DateTime? fromJson(Object? timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  @override
  Object? toJson(DateTime? date) => FieldValue.serverTimestamp();
}
