import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:person_note/model/person/person.dart';

abstract class PersonUsecase {
  PersonUsecase(String userId);
  Future<List<Person>> getPersonList();
  Stream<List<Person>> watchPersonList();
  Future<void> addPerson(Person person);
  Future<void> removePerson(String id);
  Future<void> editPerson(Person person);
}

class PersonUsecaseImpl implements PersonUsecase {
  final String userId;
  PersonUsecaseImpl(this.userId);
  @override
  Future<List<Person>> getPersonList() async {
    final collectionRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons')
        .get();
    return collectionRef.docs.map((e) => Person.fromJson(e.data())).toList();
  }

  @override
  Stream<List<Person>> watchPersonList() async* {
    yield await getPersonList();
    final collectionStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons')
        .snapshots();
    await for (final snapshot in collectionStream) {
      yield snapshot.docs.map((docRef) {
        return Person.fromJson(docRef.data());
      }).toList();
    }
  }

  @override
  Future<void> addPerson(Person person) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons');
    final docRef = collectionRef.doc();
    await docRef.set(person.copyWith(id: docRef.id).toJson());
  }

  @override
  Future<void> removePerson(String id) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons')
        .doc(id);
    await docRef.delete();
  }

  @override
  Future<void> editPerson(Person person) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('persons')
        .doc(person.id);
    await docRef.update(person.toJson());
  }
}
