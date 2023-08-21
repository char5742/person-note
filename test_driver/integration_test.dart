import 'dart:io';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  try {
    await integrationDriver(
      onScreenshot: (
        String screenshotName,
        List<int> screenshotBytes, [
        Map<String, Object?>? someParameter,
      ]) async {
        final image = await File('screen_shots/$screenshotName.png')
            .create(recursive: true);
        image.writeAsBytesSync(screenshotBytes);
        return true;
      },
    );
  } on Exception catch (e) {
    debugPrint('Exception occured: $e');
  }
}
