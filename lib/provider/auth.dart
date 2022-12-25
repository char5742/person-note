import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/usecase/auth.dart';

final authProvider = Provider<AuthUsecase>((_) => AuthUsecaseImpl.instance);

final myAccountProvider = StateProvider<UserCredential?>((_) => null);

final personList = Provider((ref) {
  FirebaseDatabase.instance.ref();
});
