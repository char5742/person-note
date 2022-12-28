import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/usecase/auth.dart';

final authProvider = Provider<AuthUsecase>((_) => AuthUsecaseImpl.instance);
