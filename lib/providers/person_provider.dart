import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/models/person/person_model.dart';
import 'package:person_note/providers/account_provider.dart';
import 'package:person_note/services/person_service.dart';

final personServiceProvider = Provider<PersonServiceAbstract>((ref) {
  final uid = ref.watch(accountServiceProvider.select((value) => value?.uid));
  if (uid == null) {
    throw Exception('Require to sign in first.');
  }
  return PersonServiceWithFirebase(uid);
});

final personListProvider = StreamProvider<List<Person>>(
  (ref) => ref.watch(personServiceProvider).watchPersonList(),
);

final personByIdProvider = FutureProvider.family.autoDispose<Person, String>(
  (ref, arg) async => ref.watch(
    personListProvider.selectAsync(
      (data) => data.firstWhere((element) => element.id == arg),
    ),
  ),
);
