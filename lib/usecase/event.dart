import 'package:firebase_database/firebase_database.dart';
import 'package:person_note/model/event/event.dart';

abstract class EventUsecase {
  EventUsecase(String userId);
  Future<List<Event>> getEventList();
  Stream<List<Event>> watchEventList();
  Future<void> addEvent(Event event);
  Future<void> removeEvent(String id);
  Future<void> editEvent(Event event);
}

class EventUsecaseImpl implements EventUsecase {
  final String userId;
  EventUsecaseImpl(this.userId);
  @override
  Future<List<Event>> getEventList() async {
    final event = await FirebaseDatabase.instance.ref('event/$userId').once();
    if (!event.snapshot.exists) return [];
    return (event.snapshot.value as Map?)
            ?.values
            .map((value) => Event.fromJson(Map<String, Object>.from(value)))
            .toList() ??
        [];
  }

  @override
  Stream<List<Event>> watchEventList() async* {
    final stream = FirebaseDatabase.instance.ref('event/$userId').onValue;
    await for (final event in stream) {
      yield (event.snapshot.value as Map?)
              ?.values
              .map((value) => Event.fromJson(Map<String, Object>.from(value)))
              .toList() ??
          [];
    }
  }

  @override
  Future<void> addEvent(Event event) async {
    final newEventRef = FirebaseDatabase.instance.ref('event/$userId').push();
    await newEventRef.set(event.copyWith(id: newEventRef.key!).toJson());
  }

  @override
  Future<void> removeEvent(String id) async {
    await FirebaseDatabase.instance.ref('event/$userId/$id').remove();
  }

  @override
  Future<void> editEvent(Event event) async {
    final ref = FirebaseDatabase.instance.ref('event/$userId/${event.id}');
    await ref.set(event.toJson());
  }
}
