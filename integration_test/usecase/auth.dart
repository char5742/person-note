import 'dart:async';

import 'package:person_note/model/auth/account.dart';
import 'package:person_note/usecase/auth.dart';

class AuthUsecaseTestImpl implements AuthUsecase {
  AuthUsecaseTestImpl._internal();
  factory AuthUsecaseTestImpl() => instance;
  static final AuthUsecaseTestImpl instance = AuthUsecaseTestImpl._internal();

  final accountStream = StreamController<Account?>();
  bool isFirstCall = true;
  @override
  Future<Account?> currentAccount() async {
    return null;
  }

  @override
  Future<void> init() async {}

  @override
  Stream<Account?> get onCurrentUserChanged => accountStream.stream;

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
