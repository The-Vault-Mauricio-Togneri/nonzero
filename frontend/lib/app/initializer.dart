import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:nonzero/services/navigation.dart';
import 'package:nonzero/services/palette.dart';
import 'package:url_strategy/url_strategy.dart';

final GetIt getIt = GetIt.instance;

class Initializer {
  static Future set() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyAnidizUg0ktmSgulrs2qXWbR5oO-WYbVE',
          appId: '1:631296600620:web:3e1dd4ed0e9ac5741eff89',
          messagingSenderId: '631296600620',
          projectId: 'non-zero',
        ),
      );
    } else {
      await Firebase.initializeApp();
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Palette.transparent,
    ));

    setPathUrlStrategy();

    getIt.registerSingleton<Navigation>(Navigation());
  }
}
