import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/settings_hints.dart';
import 'package:cogboardmobileapp/screens/settings_project_list.dart';
import 'package:cogboardmobileapp/screens/settings_view_mode.dart';
import 'package:cogboardmobileapp/screens/settings_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  // TODO: #13, #14
  @override
  Widget build(BuildContext context) {
//    final settingsProvider = Provider.of<SettingsProvider>(context);
//    final settingsProjects = settingsProvider.connections;
//    final widgetProjects = settingsProvider.widgets;

//    settingsProvider.initialValue();

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: FutureBuilder(
          future: Provider.of<SettingsProvider>(context, listen: false).fetchSettingsConfig(),
          builder: (ctx, dataSnapshot) {
            return Consumer<SettingsProvider>(builder: (ctx, settingsProvider, child) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SettingsProjectListScreen(settingsProvider.connections),
                      Divider(
                        color: Colors.grey,
                        indent: 30,
                        endIndent: 30,
                      ),
                      SettingsViewMode(settingsProvider.viewMode),
                      Divider(
                        color: Colors.grey,
                        indent: 30,
                        endIndent: 30,
                      ),
                      SettingsWidgets(settingsProvider.widgets, settingsProvider.sortBy),
                      Divider(
                        color: Colors.grey,
                        indent: 30,
                        endIndent: 30,
                      ),
                      SettingsHints(settingsProvider.showHints),
                    ],
                  ),
                ),
              );
            });
          }),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
