import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:person_note/app.dart';
import 'package:person_note/provider/auth.dart';
import 'package:person_note/provider/event.dart';
import 'package:person_note/provider/person.dart';

import 'usecase/auth.dart';
import 'usecase/event.dart';
import 'usecase/person.dart';

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding();

  testWidgets('screenshot', (WidgetTester tester) async {
    // Render the UI of the app
    await initializeDateFormatting();
    await AuthUsecaseTestImpl.instance.init();
    await tester.pumpWidget(ProviderScope(
      overrides: [
        authProvider.overrideWith((_) => AuthUsecaseTestImpl.instance),
        personProvider.overrideWith((_) => PersonUsecaseTestImpl('')),
        eventProvider.overrideWith((_) => EventUsecaseTestImpl('')),
      ],
      child: const App(),
    ));
    binding.convertFlutterSurfaceToImage();
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
