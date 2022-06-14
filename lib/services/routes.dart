import 'package:flutter/widgets.dart';
import 'package:nonzero/app/initializer.dart';

class Routes {
  static Routes get get => getIt<Routes>();

  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static BuildContext context() => get.key.currentContext!;

  static void backTo(RoutePredicate predicate) => get.key.currentState?.popUntil(predicate);

  static void pop<T>([T? result]) => get.key.currentState?.pop(result);

  static Future<T?>? push<T>(Route<T> route) => get.key.currentState?.push(route);

  static Future<T?>? pushReplacement<T>(Route<T> route) => get.key.currentState?.pushReplacement(route);
}
