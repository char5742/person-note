import 'dart:io';

import 'package:intl/intl.dart';

void platformSpecificSetup() {
  Intl.defaultLocale = Platform.localeName;
}
