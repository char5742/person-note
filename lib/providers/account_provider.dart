import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/models/account/account_model.dart';
import 'package:person_note/providers/auth_provider.dart';

final accountServiceProvider = Provider<Account?>((ref) {
  ref.watch(authServiceProvider).userChanges.listen((account) {
    ref.state = account;
  });
  return ref.watch(authServiceProvider).currentAccount();
});
