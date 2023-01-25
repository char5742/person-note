import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/page/detail/event/event_edit.dart';
import 'package:person_note/provider/account.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'const/color.dart';
import 'page/create.dart';
import 'page/detail/detail.dart';
import 'page/detail/edit.dart';
import 'page/detail/event/event_create.dart';
import 'page/login.dart';
import 'page/top.dart';

// GoRouter configuration
final _routerProvider = Provider(
  (ref) => GoRouter(
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
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) =>
                    EditPage(personId: state.queryParams['id']!),
              ),
              GoRoute(
                path: 'create_event',
                builder: (context, state) =>
                    EventCreatePage(personId: state.queryParams['id']!),
              ),
              GoRoute(
                path: 'edit_event',
                builder: (context, state) =>
                    EventEditPage(eventId: state.queryParams['event_id']!),
              ),
            ],
          ),
        ],
      ),
    ],
  ),
);

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      theme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
      ),
      darkTheme: ThemeData.from(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: ref.watch(_routerProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
