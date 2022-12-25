import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/person/person.dart';
import 'package:person_note/provider/auth.dart';
import 'package:person_note/usecase/person.dart';

final personProvider = Provider(
    (ref) => PersonUsecaseImpl(ref.watch(myAccountProvider)!.user!.uid));

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
