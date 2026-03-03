import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUrlLauncher {
  static final Logger _logger = Logger();

  static Future<bool> launch(String? url) async {
    if (url == null || url.isEmpty) {
      _logger.e('URL is null or empty');
      return false;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      _logger.e('Invalid URL: $url');
      return false;
    }

    if (!await canLaunchUrl(uri)) {
      _logger.e('Cannot launch: $url');
      return false;
    }

    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

    return success;
  }

  static Future<bool> checkAndLaunch(String? url) async {
    if (url == null || url.isEmpty) return false;

    final formattedUrl =
        (!url.startsWith('http://') && !url.startsWith('https://'))
        ? 'https://$url'
        : url;

    return launch(formattedUrl);
  }
}
