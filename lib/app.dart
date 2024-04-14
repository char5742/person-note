import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/pages/detail_page/event_page/event_edit_page.dart';
import 'package:person_note/providers/account_provider.dart';

import 'const/color.dart';
import 'pages/create_page.dart';
import 'pages/detail_page/detail_page.dart';
import 'pages/detail_page/edit_page.dart';
import 'pages/detail_page/event_page/event_create_page.dart';
import 'pages/login_page.dart' if (dart.library.html) 'pages/login_page_web.dart';
import 'pages/top_page.dart';

// GoRouter configuration
final _routerProvider = Provider(
  (ref) => GoRouter(
    redirect: (context, state) async {
      if (ref.watch(accountServiceProvider) == null) {
        return state.path == '/login' ? null : '/login';
      }
      // Transition to the top page after the login process is complete.
      if (state.path == '/login') {
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
            path: 'person/:id',
            builder: (context, state) =>
                DetailPage(personId: state.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) =>
                    EditPage(personId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: 'event/create',
                builder: (context, state) =>
                    EventCreatePage(personId: state.pathParameters['id']!),
              ),
              GoRoute(
                path: 'event/:event_id/edit',
                builder: (context, state) =>
                    EventEditPage(eventId: state.pathParameters['event_id']!),
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
