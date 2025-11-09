import 'dart:async';

import 'package:calling_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  _configureLogging();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final widget = await builder();
  runApp(ProviderScope(child: widget));
}

void _configureLogging() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('[${record.time.toIso8601String()}] ${record.level.name} '
        '${record.loggerName}: ${record.message}');
  });
}
