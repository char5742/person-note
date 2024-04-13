import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/models/event/event_model.dart';
import 'package:person_note/providers/account_provider.dart';
import 'package:person_note/services/event_service.dart';

final eventServiceProvider = Provider<EventServiceAbstract>((ref) {
  final uid = ref.watch(accountServiceProvider.select((value) => value?.uid));
  if (uid == null) {
    throw Exception('Require to sign in first.');
  }
  return EventServiceWithFirebase(uid);
});

final eventListProvider = StreamProvider<List<Event>>(
  (ref) => ref.watch(eventServiceProvider).watchEventList(),
);

final eventByIdProvider = FutureProvider.family.autoDispose<Event, String>(
  (ref, arg) async => ref.watch(
    eventListProvider.selectAsync(
      (data) => data.firstWhere((element) => element.id == arg),
    ),
  ),
);

final eventByPersonIdProvider =
    StreamProvider.family.autoDispose<List<Event>, String>(
  (ref, personId) =>
      ref.watch(eventServiceProvider).watchEventListByPersonId(personId),
);
