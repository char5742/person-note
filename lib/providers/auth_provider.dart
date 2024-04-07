import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/services/auth_service.dart';

final authServiceProvider =
    Provider<AuthServiceAbstract>((_) => AuthServiceWithFirebase());
