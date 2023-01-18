import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/event/event.dart';
import 'package:person_note/provider/account.dart';
import 'package:person_note/usecase/event.dart';

final eventProvider = Provider<EventUsecase>((ref) {
  final uid = ref.watch(accountProvider.select((value) => value?.uid));
  if (uid == null) {
    throw Exception("Require to sign in first.");
  }
  return EventUsecaseImpl(uid);
});

final eventListProvider = StreamProvider<List<Event>>(
  (ref) => ref.watch(eventProvider).watchEventList(),
);

final eventByIdProvider = FutureProvider.family.autoDispose<Event, String>(
  (ref, arg) async => ref
      .watch(eventListProvider)
      .asData!
      .value
      .firstWhere((element) => element.id.toString() == arg),
);

final eventByPersonIdProvider =
    FutureProvider.family.autoDispose<List<Event>, String>(
  (ref, personId) async => ref
      .watch(eventListProvider)
      .asData!
      .value
      .where((element) => (element.personIdList ?? []).contains(personId))
      .toList(),
);
