import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'desktop/main.dart';
import 'mobile/main.dart';

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop) {
    runDesktopApp();
  } else {
    runMobileApp();
  }
}
