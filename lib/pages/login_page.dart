import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/const/color.dart';
import 'package:person_note/gen/assets.gen.dart';
import 'package:person_note/providers/auth_provider.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // want to be able to choose how to log in.
    void signIn() {
      ref.read(authServiceProvider).signIn();
    }

    useEffect(
      () {
        signIn();
        return null;
      },
      [],
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Assets.img.appLogo.svg(
              theme: const SvgTheme(currentColor: seedColor),
            ),
            ElevatedButton(
              onPressed: signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
