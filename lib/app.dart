import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'page/create.dart';
import 'page/detail.dart';
import 'page/top.dart';

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TopPage(),
      routes: [
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
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
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
      routerConfig: _router,
    );
  }
}
