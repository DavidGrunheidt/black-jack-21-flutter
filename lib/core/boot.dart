import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../my_app.dart';
import 'firebase_options/firebase_options.dart';

Future<void> boot() async {
  return runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: currentPlatform);

    FlutterError.onError = (details) async {
      FlutterError.presentError(details);

      if (kIsWeb) return;
      return FirebaseCrashlytics.instance.recordFlutterError(details, fatal: true);
    };

    if (!kIsWeb) {
      Isolate.current.addErrorListener(RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        final stackTrace = StackTrace.fromString(errorAndStacktrace.last.toString());
        return FirebaseCrashlytics.instance.recordError(errorAndStacktrace.first, stackTrace);
      }).sendPort);
    }

    runApp(const MyApp());
  }, (error, stack) async {
    if (kDebugMode) debugPrint('Unhandled Error: $error StackTrace: $stack');
    if (kIsWeb) return;

    return FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}
