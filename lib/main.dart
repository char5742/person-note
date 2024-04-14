import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/providers/auth_provider.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'setup_native.dart' if (dart.library.html) 'setup_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  platformSpecificSetup();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final container = ProviderContainer();
  await container.read(authServiceProvider).init();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
