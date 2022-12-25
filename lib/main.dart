import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:person_note/provider/auth.dart';
import 'package:person_note/usecase/auth.dart';

import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthUsecaseImpl.instance.init();
  UserCredential? myAccount;
  if (await GoogleSignIn().isSignedIn()) {
    myAccount = await AuthUsecaseImpl.instance.signInWithGoogle();
  }
  runApp(ProviderScope(
    overrides: [
      myAccountProvider.overrideWith((ref) => myAccount),
    ],
    child: const App(),
  ));
}
