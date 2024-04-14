import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/services/auth_service/auth_service.dart';

final authServiceProvider =
    Provider<AbstractAuthService>((_) => AuthServiceWithFirebase());
