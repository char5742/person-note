import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:person_note/model/auth/account.dart';

abstract class AuthUsecase {
  Future<Account?> signInWithGoogle();

  /// Returns a future that Account if already signedIn.
  Future<Account?> currentAccount();

  /// Require call in main funciton
  Future<void> init();
}

class AuthUsecaseImpl implements AuthUsecase {
  AuthUsecaseImpl._internal();
  factory AuthUsecaseImpl() => instance;
  static final AuthUsecaseImpl instance = AuthUsecaseImpl._internal();

  @override
  Future<Account?> currentAccount() async {
    if (await GoogleSignIn().isSignedIn()) {
      return await AuthUsecaseImpl.instance.signInWithGoogle();
    }
    return null;
  }

  @override
  Future<Account?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

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
    return Account(uid: user.uid, displayName: user.displayName ?? 'Unknown');
  }

  @override
  Future<void> init() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref('users/${user.uid}');
        final snapshot = await ref.get();
        if (!snapshot.exists) {
          await ref.set({
            "displayName": user.displayName,
            "createdAt": ServerValue.timestamp,
          });
        }
      }
    });
  }
}
