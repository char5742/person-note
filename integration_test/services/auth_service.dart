import 'dart:async';

import 'package:flutter/material.dart';
import 'package:person_note/models/account/account_model.dart';
import 'package:person_note/services/auth_service/auth_service.dart';

class AuthServiceTestImpl implements AbstractAuthService {
  final accountStream = StreamController<Account?>();
  bool isFirstCall = true;

  @override
  Widget renderButton() {
    return ElevatedButton(
      onPressed: signIn,
      child: const Text('Sign In'),
    );
  }

  @override
  Account? currentAccount() {
    return null;
  }

  @override
  Future<void> init() async {}

  @override
  Stream<Account?> get userChanges => accountStream.stream;

  @override
  Future<Account?> signIn() async {
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
