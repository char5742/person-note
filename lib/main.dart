import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:person_note/usecase/auth.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'util/native.dart' if (dart.library.html) 'util/web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = getCurrentLocale();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthUsecaseImpl.instance.init();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
