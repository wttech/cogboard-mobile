import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IframeEmbedWidget extends StatelessWidget {
  final DashboardWidget widget;

  IframeEmbedWidget({
    this.widget,
  });

  String get iframeUrl {
    return widget.content['iframeUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '<iframe/>',
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
