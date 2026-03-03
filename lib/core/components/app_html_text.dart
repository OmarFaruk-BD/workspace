import 'package:flutter/material.dart';
import 'package:workspace/core/service/app_url_launcher.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AppHtmlWidget extends StatelessWidget {
  const AppHtmlWidget({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) return const SizedBox();

    return HtmlWidget(
      text ?? '<p> </p>',
      onTapUrl: (url) async {
        await AppUrlLauncher.launch(url);
        return true;
      },
    );
  }
}
