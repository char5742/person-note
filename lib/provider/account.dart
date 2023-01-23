import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/account/account.dart';
import 'package:person_note/provider/auth.dart';

final accountProvider = Provider<Account?>((ref) {
  ref.watch(authProvider).userChanges.listen((account) {
    ref.state = account;
  });
  return ref.watch(authProvider).currentAccount();
});
