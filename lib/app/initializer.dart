import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:nonzero/services/palette.dart';
import 'package:nonzero/services/routes.dart';

final GetIt getIt = GetIt.instance;

class Initializer {
  static Future set() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Palette.transparent,
    ));

    getIt.registerSingleton<Routes>(Routes());
  }
}
