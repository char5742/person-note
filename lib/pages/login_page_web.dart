import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/const/color.dart';
import 'package:person_note/gen/assets.gen.dart';
import 'package:person_note/providers/auth_provider.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Assets.img.appLogo.svg(
              theme: const SvgTheme(currentColor: seedColor),
            ),
            ref.watch(authServiceProvider).renderButton(),
          ],
        ),
      ),
    );
  }
}
