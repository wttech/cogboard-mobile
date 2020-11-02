import 'package:cogboardmobileapp/screens/settings_hints.dart';
import 'package:cogboardmobileapp/screens/settings_project_list.dart';
import 'package:cogboardmobileapp/screens/settings_sort_by.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).getTranslation('settingsScreen.title')),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SettingsProjectListScreen(),
              Divider(
                color: Colors.grey,
                indent: 30,
                endIndent: 30,
              ),
              SettingsWidgets(),
              Divider(
                color: Colors.grey,
                indent: 30,
                endIndent: 30,
              ),
              SettingsHints(),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
