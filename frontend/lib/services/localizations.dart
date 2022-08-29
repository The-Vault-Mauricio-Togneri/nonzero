import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class BaseLocalized {
  String get appName;

  String get buttonCancel;

  String get buttonOk;

  String get confirmationDeleteTask;

  String get connectionSignIn;

  String get fieldCantBeEmpty;

  String get listEmpty;

  String get optionDelete;

  String get optionDone;

  String get optionNotDone;

  String get optionUpdate;

  String get priorityHigh;

  String get priorityLow;

  String get priorityMedium;

  String get taskButtonAdd;

  String get taskButtonUpdate;

  String get taskFieldName;

  String get taskTitleNew;

  String get taskTitleUpdate;
}

class ENLocalized extends BaseLocalized {
  @override
  String get appName => 'Non Zero';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonOk => 'Ok';

  @override
  String get confirmationDeleteTask => 'Delete task?';

  @override
  String get connectionSignIn => 'Sign in';

  @override
  String get fieldCantBeEmpty => "can't be empty";

  @override
  String get listEmpty => 'No tasks';

  @override
  String get optionDelete => 'Delete';

  @override
  String get optionDone => 'Done';

  @override
  String get optionNotDone => 'Not done';

  @override
  String get optionUpdate => 'Update';

  @override
  String get priorityHigh => 'High';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get taskButtonAdd => 'Add';

  @override
  String get taskButtonUpdate => 'Update';

  @override
  String get taskFieldName => 'Name';

  @override
  String get taskTitleNew => 'New task';

  @override
  String get taskTitleUpdate => 'Update task';
}

class ESLocalized extends BaseLocalized {
  @override
  String get appName => 'Non Zero';

  @override
  String get buttonCancel => 'Canceler';

  @override
  String get buttonOk => 'Ok';

  @override
  String get confirmationDeleteTask => '¿Elimiar tarea?';

  @override
  String get connectionSignIn => 'Conectarse';

  @override
  String get fieldCantBeEmpty => 'no puede esta vacío';

  @override
  String get listEmpty => 'Sin tareas';

  @override
  String get optionDelete => 'Eliminar';

  @override
  String get optionDone => 'Completada';

  @override
  String get optionNotDone => 'No completada';

  @override
  String get optionUpdate => 'Actualizar';

  @override
  String get priorityHigh => 'Alta';

  @override
  String get priorityLow => 'Baja';

  @override
  String get priorityMedium => 'Media';

  @override
  String get taskButtonAdd => 'Agregar';

  @override
  String get taskButtonUpdate => 'Actualizar';

  @override
  String get taskFieldName => 'Nombre';

  @override
  String get taskTitleNew => 'Nueva tarea';

  @override
  String get taskTitleUpdate => 'Actualizar tarea';
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
