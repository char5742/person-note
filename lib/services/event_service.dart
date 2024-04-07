import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:person_note/models/event/event_model.dart';

abstract interface class EventServiceAbstract {
  EventServiceAbstract();
  Future<List<Event>> getEventList();
  Stream<List<Event>> watchEventList();
  Stream<List<Event>> watchEventListByPersonId(String personId);
  Future<void> addEvent(Event event);
  Future<void> removeEvent(String id);
  Future<void> editEvent(Event event);
}

class EventServiceWithFirebase implements EventServiceAbstract {
  EventServiceWithFirebase(this.userId);
  final String userId;
  @override
  Future<List<Event>> getEventList() async {
    final collectionRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .get();
    return collectionRef.docs.map((e) => Event.fromJson(e.data())).toList();
  }

  @override
  Stream<List<Event>> watchEventList() async* {
    final collectionStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .snapshots();
    await for (final snapshot in collectionStream) {
      yield snapshot.docs
          .map((docRef) => Event.fromJson(docRef.data()))
          .toList();
    }
  }

  @override
  Stream<List<Event>> watchEventListByPersonId(String personId) async* {
    final collectionStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .where('personIdList', arrayContains: personId)
        .snapshots();
    await for (final snapshot in collectionStream) {
      yield snapshot.docs
          .map((docRef) => Event.fromJson(docRef.data()))
          .toList();
    }
  }

  @override
  Future<void> addEvent(Event event) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events');
    final docRef = collectionRef.doc();
    await docRef.set(event.copyWith(id: docRef.id).toJson());
  }

  @override
  Future<void> removeEvent(String id) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(id);
    await docRef.delete();
  }

  @override
  Future<void> editEvent(Event event) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('events')
        .doc(event.id);
    await docRef.update(event.toJson());
  }
}
