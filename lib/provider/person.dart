import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/person/person.dart';

final personListProvider = StateProvider<List<Person>>(
  (_) => [
    Person(
      id: 0,
      name: 'Char',
      memo: 'self',
      tags: ['self', 'anime'],
      updated: DateTime.now(),
      created: DateTime.now(),
    ),
  ],
);

final personByIdProvider = Provider.family.autoDispose<Person, String>(
    (ref, arg) => ref
        .watch(personListProvider)
        .firstWhere((element) => element.id.toString() == arg));
