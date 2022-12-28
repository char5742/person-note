import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/provider/account.dart';

import 'page/create.dart';
import 'page/detail.dart';
import 'page/login.dart';
import 'page/top.dart';

// GoRouter configuration
final _routerProvider = Provider((ref) => GoRouter(
      redirect: (context, state) async {
        if (ref.watch(accountProvider) == null) {
          return state.subloc == '/login' ? null : '/login';
        }
        // Transition to the top page after the login process is complete.
        if (state.subloc == '/login') {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TopPage(),
          routes: [
            GoRoute(
              path: 'login',
              builder: (context, state) => const LoginPage(),
            ),
            GoRoute(
              path: 'create',
              builder: (context, state) => const CreatePage(),
            ),
            GoRoute(
              path: 'detail',
              builder: (context, state) =>
                  DetailPage(personId: state.queryParams['id']!),
            ),
          ],
        ),
      ],
    ));

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF38d18c),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF38d18c),
        brightness: Brightness.dark,
      ),
      routerConfig: ref.watch(_routerProvider),
    );
  }
}
