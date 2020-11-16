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
    return iframeUrl != ''
        ? Container(
            child: WebView(
              initialUrl: Uri.dataFromString(
                      '<html><body><iframe src="$iframeUrl" width="100%" height="100%"></iframe></body></html>',
                      mimeType: 'text/html')
                  .toString(),
              javascriptMode: JavascriptMode.unrestricted,
            ),
          )
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).getTranslation('iframeEmbed.blankUrl'),
                  style: TextStyle(
                    fontSize: 22,
                  ),
                )
              ],
            ),
          );
  }
}
