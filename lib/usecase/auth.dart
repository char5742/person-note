import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:person_note/model/account/account.dart';

abstract interface class AuthUsecase {
  Future<Account?> signInWithGoogle();

  /// Returns a future that Account if already signedIn.
  Account? currentAccount();

  Future<void> signOut();

  Stream<Account?> get userChanges;

  /// Require call in main funciton
  Future<void> init();
}

class AuthUsecaseImpl implements AuthUsecase {
  factory AuthUsecaseImpl() => instance;
  AuthUsecaseImpl._internal();
  static final AuthUsecaseImpl instance = AuthUsecaseImpl._internal();

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
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
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
  Future<Account?> signInWithGoogle() async {
    // Trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    final user = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => value.user);
    if (user == null) {
      return null;
    }
    return Account(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
    );
  }

  @override
  Future<void> init() async {
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
