// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show window;

String getCurrentLocale() {
  return window.navigator.language;
}
