import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/provider/auth.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // want to be able to choose how to log in.
    void signInWithGoogle() {
      ref.read(authProvider).signInWithGoogle();
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
