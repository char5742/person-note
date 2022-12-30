import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/auth/account.dart';
import 'package:person_note/provider/auth.dart';

final accountProvider = Provider<Account?>((ref) {
  ref.watch(authProvider).onCurrentUserChanged.listen((account) {
    ref.state = account;
  });
  return null;
});
