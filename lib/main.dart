import 'dart:developer';
import 'dart:io';

import 'package:clippy/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/providers/bootstrap_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(bootstrapProvider.notifier).bootstrapApp();
  const String sentryDSN = String.fromEnvironment('SENTRY_DSN');

  final deviceInfo = await _getDeviceInfo();
  final packageInfo = await PackageInfo.fromPlatform();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      log(e.toString());
    }
  }
  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDSN;
      options.tracesSampleRate = 1.0;
      options.attachStacktrace = true;
      options.debug = kDebugMode;
      options.sendDefaultPii = true;
      options.environment = kReleaseMode ? 'production' : 'development';

      options.beforeSend = (event, hint) {
        event.tags?['app_version'] = packageInfo.version;
        event.contexts['device_info'] = deviceInfo;
        return event;
      };
    },
    appRunner: () => runApp(
      const ProviderScope(
        // parent: container,
        child: AppInit(),
      ),
    ),
  );
}

Future<Map<String, dynamic>> _getDeviceInfo() async {
  final deviceInfo = DeviceInfoPlugin();
  if (kIsWeb) {
    return (await deviceInfo.webBrowserInfo).data;
  } else if (Platform.isAndroid) {
    return (await deviceInfo.androidInfo).data;
  } else if (Platform.isIOS) {
    return (await deviceInfo.iosInfo).data;
  }
  return {'platform': 'unknown'};
}
