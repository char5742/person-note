import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/person/person.dart';
import 'package:person_note/provider/account.dart';
import 'package:person_note/usecase/person.dart';

final personProvider = Provider<PersonUsecase>((ref) {
  final uid = ref.watch(accountProvider.select((value) => value?.uid));
  if (uid == null) {
    throw Exception("Require to sign in first.");
  }
  return PersonUsecaseImpl(uid);
});

final personListProvider = StreamProvider<List<Person>>(
  (ref) => ref.watch(personProvider).watchPersonList(),
);

final personByIdProvider = FutureProvider.family.autoDispose<Person, String>(
  (ref, arg) async => ref
      .watch(personListProvider)
      .asData!
      .value
      .firstWhere((element) => element.id.toString() == arg),
);
