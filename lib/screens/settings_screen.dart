import 'package:cogboardmobileapp/screens/settings_general_screen.dart';
import 'package:cogboardmobileapp/screens/settings_projects_screen.dart';
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              AppLocalizations.of(context).getTranslation('settingsScreen.projects'),
            ),
            onTap: () => Navigator.of(context).pushNamed(SettingsProjectsScreen.routeName),
          ),
          ListTile(
            title: Text(
              AppLocalizations.of(context).getTranslation('settingsScreen.general'),
            ),
            onTap: () => Navigator.of(context).pushNamed(SettingsGeneralScreen.routeName),
          ),
          Divider(
            color: Theme.of(context).colorScheme.surface,
            thickness: 5,
          ),
        ],
      ),
    );
  }
}
