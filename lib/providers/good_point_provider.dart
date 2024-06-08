import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/models/person/good_point/good_point_model.dart';
import 'package:person_note/providers/account_provider.dart';
import 'package:person_note/services/good_point_service.dart';

final goodPointServiceProvider =
    Provider.family<GoodPointServiceAbstract, String>((ref, personId) {
  final uid = ref.watch(accountServiceProvider.select((value) => value?.uid));
  if (uid == null) {
    throw Exception('Require to sign in first.');
  }
  return GoodPointServiceWithFirebase(
    userId: uid,
    personId: personId,
  );
});

final goodPointListProvider =
    StreamProvider.family.autoDispose<List<GoodPoint>, String>(
  (ref, personId) =>
      ref.watch(goodPointServiceProvider(personId)).watchGoodPointList(),
);

final goodPointByIdProvider = FutureProvider.family
    .autoDispose<GoodPoint, ({String personId, String goodPointId})>(
  (ref, args) async => ref.watch(
    goodPointListProvider(args.personId).selectAsync(
      (data) => data.firstWhere((element) => element.id == args.goodPointId),
    ),
  ),
);
