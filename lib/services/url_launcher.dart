import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static Future<bool> open(String url) async => launchUrl(Uri.parse(url));
}
