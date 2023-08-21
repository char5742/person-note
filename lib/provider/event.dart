import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/event/event.dart';
import 'package:person_note/provider/account.dart';
import 'package:person_note/usecase/event.dart';

final eventProvider = Provider<EventUsecase>((ref) {
  final uid = ref.watch(accountProvider.select((value) => value?.uid));
  if (uid == null) {
    throw Exception('Require to sign in first.');
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
      .firstWhere((element) => element.id == arg),
);

final eventByPersonIdProvider =
    StreamProvider.family.autoDispose<List<Event>, String>(
  (ref, personId) =>
      ref.watch(eventProvider).watchEventListByPersonId(personId),
);
