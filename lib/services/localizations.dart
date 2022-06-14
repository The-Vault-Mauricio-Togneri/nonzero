import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class BaseLocalized {
  String get dialogLoadingApplying;

  String get dialogLoadingLoading;

  String get dialogLoadingSaving;

  String get dialogLoadingSearching;

  String get dialogLoadingUpdating;

  String get formErrorEmpty;

  String get loginButtonLogin;

  String get loginFieldEmail;

  String get loginFieldPassword;
}

class ENLocalized extends BaseLocalized {
  @override
  String get dialogLoadingApplying => 'Applying…';

  @override
  String get dialogLoadingLoading => 'Loading…';

  @override
  String get dialogLoadingSaving => 'Saving…';

  @override
  String get dialogLoadingSearching => 'Searching…';

  @override
  String get dialogLoadingUpdating => 'Updating…';

  @override
  String get formErrorEmpty => 'Please enter some text';

  @override
  String get loginButtonLogin => 'Login';

  @override
  String get loginFieldEmail => 'Email';

  @override
  String get loginFieldPassword => 'Password';
}

class ESLocalized extends BaseLocalized {
  @override
  String get dialogLoadingApplying => 'Paramétrage en cours…';

  @override
  String get dialogLoadingLoading => 'Un instant...';

  @override
  String get dialogLoadingSaving => 'Sauvegarde en cours…';

  @override
  String get dialogLoadingSearching => 'Recherche…';

  @override
  String get dialogLoadingUpdating => 'Mise à jour…';

  @override
  String get formErrorEmpty => 'Ce champs ne peut être vide';

  @override
  String get loginButtonLogin => 'Se connecter';

  @override
  String get loginFieldEmail => 'Email';

  @override
  String get loginFieldPassword => 'Mot de passe';
}

class Localized {
  static late BaseLocalized get;
  static late Locale current;

  static List<Locale> locales = localized.keys.map(Locale.new).toList();

  static Map<String, BaseLocalized> localized = <String, BaseLocalized>{'en': ENLocalized(), 'es': ESLocalized()};

  static bool isSupported(Locale locale) => locales.map((Locale l) => l.languageCode).contains(locale.languageCode);

  static void load(Locale locale) {
    current = locale;
    get = localized[locale.languageCode]!;
  }
}

class CustomLocalizationsDelegate extends LocalizationsDelegate<dynamic> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => Localized.isSupported(locale);

  @override
  Future<dynamic> load(Locale locale) {
    Localized.load(locale);
    return SynchronousFuture<dynamic>(Object());
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}
