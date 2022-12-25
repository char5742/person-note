import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthUsecase {
  Future<UserCredential> signInWithGoogle();
  Future<void> init();
}

class AuthUsecaseImpl implements AuthUsecase {
  AuthUsecaseImpl._internal();
  factory AuthUsecaseImpl() => instance;
  static final AuthUsecaseImpl instance = AuthUsecaseImpl._internal();

  @override
  Future<UserCredential> signInWithGoogle() async {
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
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
