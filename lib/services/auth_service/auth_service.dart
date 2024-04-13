import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:person_note/models/account/account_model.dart';

import 'signin_button/signin_button_none.dart'
    if (dart.library.html) 'signin_button/signin_button_web.dart'
    as signin_button;

abstract interface class AbstractAuthService {
  Future<void> signIn();
  Widget renderButton();

  /// Returns a future that Account if already signedIn.
  Account? currentAccount();

  Future<void> signOut();

  Stream<Account?> get userChanges;

  /// Require call in main funciton
  Future<void> init();
}

class AuthServiceWithFirebase implements AbstractAuthService {
  final googleSignIn = GoogleSignIn();

  @override
  Widget renderButton() => signin_button.renderButton();

  @override
  Account? currentAccount() {
    if (FirebaseAuth.instance.currentUser != null) {
      final user = FirebaseAuth.instance.currentUser!;
      return Account(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
      );
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();
  }

  @override
  Stream<Account?> get userChanges =>
      FirebaseAuth.instance.userChanges().asyncMap<Account?>(
        (user) async {
          if (user == null) {
            return null;
          }
          return Account(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
          );
        },
      );

  @override
  Future<void> signIn() async {
    await googleSignIn.signIn();
  }

  @override
  Future<void> init() async {
    googleSignIn.onCurrentUserChanged.listen((account) async {
      if (account == null) {
        return;
      }
      final googleAuth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    });
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        final docRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final snapshot = await docRef.get();
        if (!snapshot.exists) {
          await docRef.set({
            'displayName': user.displayName,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    });
  }
}
