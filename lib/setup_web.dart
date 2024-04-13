// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:intl/intl.dart';

void platformSpecificSetup() {
  setUrlStrategy(PathUrlStrategy());
  Intl.defaultLocale = window.navigator.language;
}
