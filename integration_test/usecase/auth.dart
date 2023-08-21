import 'dart:async';

import 'package:person_note/model/account/account.dart';
import 'package:person_note/usecase/auth.dart';

class AuthUsecaseTestImpl implements AuthUsecase {
  factory AuthUsecaseTestImpl() => instance;
  AuthUsecaseTestImpl._internal();
  static final AuthUsecaseTestImpl instance = AuthUsecaseTestImpl._internal();

  final accountStream = StreamController<Account?>();
  bool isFirstCall = true;
  @override
  Account? currentAccount() {
    return null;
  }

  @override
  Future<void> init() async {}

  @override
  Stream<Account?> get userChanges => accountStream.stream;

  @override
  Future<Account?> signInWithGoogle() async {
    if (isFirstCall) {
      isFirstCall = !isFirstCall;
      return null;
    }
    const account = Account(
      uid: '0000',
      email: 'person-note@sample.com',
      displayName: 'char',
    );
    accountStream.add(account);
    return account;
  }

  @override
  Future<void> signOut() async {
    accountStream.add(null);
  }
}
