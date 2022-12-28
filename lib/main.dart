import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:person_note/provider/account.dart';
import 'package:person_note/usecase/auth.dart';

import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthUsecaseImpl.instance.init();
  final account = await AuthUsecaseImpl.instance.currentAccount();
  runApp(ProviderScope(
    overrides: [
      accountProvider.overrideWith((_) => account),
    ],
    child: const App(),
  ));
}
