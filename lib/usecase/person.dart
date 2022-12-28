import 'package:firebase_database/firebase_database.dart';
import 'package:person_note/model/person/person.dart';

abstract class PersonUsecase {
  PersonUsecase(String userId);
  Future<List<Person>> getPersonList();
  Stream<List<Person>> watchPersonList();
  Future<void> addPerson(Person person);
  Future<void> removePerson(String id);
}

class PersonUsecaseImpl implements PersonUsecase {
  final String userId;
  PersonUsecaseImpl(this.userId);
  @override
  Future<List<Person>> getPersonList() async {
    final event = await FirebaseDatabase.instance.ref('note/$userId').once();
    if (!event.snapshot.exists) return [];
    return (event.snapshot.value as Map)
        .values
        .map((value) => Person.fromJson(Map<String, Object>.from(value)))
        .toList();
  }

  @override
  Stream<List<Person>> watchPersonList() async* {
    final stream = FirebaseDatabase.instance.ref('note/$userId').onValue;
    await for (final event in stream) {
      yield (event.snapshot.value as Map)
          .values
          .map((value) => Person.fromJson(Map<String, Object>.from(value)))
          .toList();
    }
  }

  @override
  Future<void> addPerson(Person person) async {
    final newPersonRef = FirebaseDatabase.instance.ref('note/$userId').push();
    await newPersonRef.set(person.copyWith(id: newPersonRef.key!).toJson());
  }

  @override
  Future<void> removePerson(String id) async {
    await FirebaseDatabase.instance.ref('note/$userId/$id').remove();
  }
}
