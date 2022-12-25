import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/provider/auth.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // want to be able to choose how to log in.
    useEffect(() {
      ref.read(authProvider).signInWithGoogle().then((value) {
        ref.read(myAccountProvider.notifier).state = value;
        context.go('/');
      });
      return null;
    }, []);
    return const Scaffold();
  }
}
