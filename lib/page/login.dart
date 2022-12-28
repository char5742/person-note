import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/provider/account.dart';
import 'package:person_note/provider/auth.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // want to be able to choose how to log in.
    void signInWithGoogle() {
      ref.read(authProvider).signInWithGoogle().then((account) {
        ref.read(accountProvider.notifier).state = account;
        context.go('/');
      });
    }

    useEffect(() {
      signInWithGoogle();
      return null;
    }, []);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: signInWithGoogle,
          child: const Text("Sign In"),
        ),
      ),
    );
  }
}
