import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/dashboards_screen.dart';
import 'package:cogboardmobileapp/screens/settings_general_screen.dart';
import 'package:cogboardmobileapp/screens/settings_projects_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              title: Text('Projects'),
              onTap: () => Navigator.of(context).pushNamed(SettingsProjectsScreen.routeName),
            ),
            ListTile(
              title: Text('General'),
              onTap: () => Navigator.of(context).pushNamed(SettingsGeneralScreen.routeName),
            ),
            Divider(
              color: Theme.of(context).colorScheme.surface,
              thickness: 5,
            ),
          ],
        )
        // SingleChildScrollView(
        //   child: Container(
        //     child: Column(
        //       children: <Widget>[
        //         SettingsProjectListScreen(),
        //         Divider(
        //           color: Colors.grey,
        //           indent: 30,
        //           endIndent: 30,
        //         ),
        //         SettingsWidgets(),
        //         Divider(
        //           color: Colors.grey,
        //           indent: 30,
        //           endIndent: 30,
        //         ),
        //         SettingsHints(),
        //         Divider(
        //           color: Colors.grey,
        //           indent: 30,
        //           endIndent: 30,
        //         ),
        //         SettingsNotifications(),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
