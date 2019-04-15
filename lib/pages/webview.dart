import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../components/text_style.dart';
import '../components/app_activity_indicator.dart';

class WebPage extends StatelessWidget {
  final String url;
  final String title;

  WebPage({@required this.url, @required this.title});

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        title: Text(
          title,
          style: AppTextStyle.appHeader,
        ),
        elevation: 0.5,
        centerTitle: true,
      ),
      withZoom: true,
      scrollBar: true,
      withLocalStorage: true,
      enableAppScheme: true,
      hidden: true,
      withJavascript: true,
      initialChild: Center(
        child: const AppSpinner(),
      ),
    );
  }
}
