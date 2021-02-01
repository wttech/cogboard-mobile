import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

mixin UrlLauncher {
  void _displayToast(BuildContext context) {
    Toast.show(
      AppLocalizations.of(context).getTranslation('urlLauncher.toast'),
      context,
      duration: Toast.LENGTH_LONG,
      gravity: Toast.BOTTOM,
    );
  }

  Future<void> launchUrl(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      try {
        await launch(url);
      } catch (e) {
        _displayToast(context);
      }
    } else {
      _displayToast(context);
    }
  }
}
