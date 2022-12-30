import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:person_note/usecase/auth.dart';

import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthUsecaseImpl.instance.init();
  await AuthUsecaseImpl.instance.currentAccount();
  runApp(const ProviderScope(
    child: App(),
  ));
}
