import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/pages/detail_page/good_point_page/good_point_create_page.dart';
import 'package:person_note/providers/account_provider.dart';

import 'pages/create_page.dart';
import 'pages/detail_page/detail_page.dart';
import 'pages/detail_page/edit_page.dart';
import 'pages/detail_page/event_page/event_create_page.dart';
import 'pages/detail_page/event_page/event_edit_page.dart';
import 'pages/login_page.dart'
    if (dart.library.html) 'pages/login_page_web.dart';
import 'pages/top_page.dart';

// GoRouter configuration
final routerProvider = Provider(
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
            builder: (context, state) => DetailPage(
              personId: state.pathParameters['id']!,
              tab: DetailPageTab.values
                  .byName(state.uri.queryParameters['tab'] ?? 'event'),
            ),
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
              GoRoute(
                path: 'goodPoint/create',
                pageBuilder: (context, state) => DialogPage(
                  builder: (_) => GoodPointCreatePage(
                    personId: state.pathParameters['id']!,
                  ),
                ),
              ),
              // GoRoute(
              //   path: 'goodPoint/:event_id/edit',
              //   builder: (context, state) =>
              //       EventEditPage(eventId: state.pathParameters['event_id']!),
              // ),
            ],
          ),
        ],
      ),
    ],
  ),
);

class DialogPage<T> extends Page<T> {
  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes,
    );
  }
}
