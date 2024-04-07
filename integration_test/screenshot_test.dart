import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:person_note/app.dart';
import 'package:person_note/providers/auth_provider.dart';
import 'package:person_note/providers/event_provider.dart';
import 'package:person_note/providers/person_provider.dart';

import 'services/auth_service.dart';
import 'services/event_service.dart';
import 'services/person_service.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();

  testWidgets('screenshot', (WidgetTester tester) async {
    // Render the UI of the app
    final authService =  AuthServiceTestImpl();
    await authService.init();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authServiceProvider.overrideWith((_) => authService),
          personServiceProvider.overrideWith((_) => PersonServiceTestImpl('')),
          eventServiceProvider.overrideWith((_) => EventServiceTestImpl('')),
        ],
        child: const App(),
      ),
    );
    await binding.convertFlutterSurfaceToImage();
    // if call pumpAndSettle only once, didn`t show App Logo.
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('login_page');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('top_page');

    await tester.tap(find.text('Matthew'));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('detail_page');

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('create_page');
  });
}
