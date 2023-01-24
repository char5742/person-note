import 'dart:async';

import 'package:person_note/model/person/person.dart';
import 'package:person_note/usecase/person.dart';

final initData = <String, Person>{
  '0': Person(
    id: '0',
    name: 'Michael',
    memo: '',
    created: DateTime.now(),
    updated: DateTime.now(),
    tags: ['schoolmate'],
  ),
  '1': Person(
    id: '1',
    name: 'Jessica',
    memo: '',
    created: DateTime.now(),
    updated: DateTime.now(),
    tags: ['schoolmate'],
  ),
  '2': Person(
    id: '2',
    name: 'Matthew',
    age: 16,
    birthday: DateTime(2023, 5, 20),
    email: 'friend2@example.com',
    memo:
        'Best friends since childhood and often play games together. And we currently attend the same school.',
    created: DateTime.now(),
    updated: DateTime.now(),
    tags: ['best', 'game', 'schoolmate'],
  ),
  '3': Person(
    id: '3',
    name: 'Amanda',
    memo: '',
    created: DateTime.now(),
    updated: DateTime.now(),
    tags: ['schoolmate', 'game'],
  ),
  '4': Person(
    id: '4',
    name: 'My friend with a long name is a great person to be around',
    memo: '',
    created: DateTime.now(),
    updated: DateTime.now(),
    tags: ['game'],
  ),
  '5': Person(
    id: '5',
    name: 'Christopher',
    memo: '',
    created: DateTime.now(),
    updated: DateTime.now(),
    tags: ['game'],
  ),
};

class PersonUsecaseTestImpl implements PersonUsecase {
  PersonUsecaseTestImpl(String _);
  final personMap = <String, Person>{...initData};
  @override
  Future<void> addPerson(Person person) async {
    personMap.addEntries({
      person.id: person.copyWith(id: (personMap.length + 1).toString())
    }.entries);
  }

  @override
  Future<List<Person>> getPersonList() async => personMap.values.toList();

  @override
  Future<void> removePerson(String id) async {
    personMap.remove(id);
  }

  @override
  Stream<List<Person>> watchPersonList() =>
      Stream.value(personMap.values.toList());

  @override
  Future<void> editPerson(Person person) async {
    personMap.update(person.id, (value) => person);
  }
}
