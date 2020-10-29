import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/settings_hints.dart';
import 'package:cogboardmobileapp/screens/settings_project_list.dart';
import 'package:cogboardmobileapp/screens/settings_sort_by.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  // TODO: #13, #14
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
//    final settingsProjects = settingsProvider.connections;
//    final widgetProjects = settingsProvider.widgets;

//    settingsProvider.initialValue();

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SettingsProjectListScreen(settingsProvider.connections),
              Divider(
                color: Colors.grey,
                indent: 30,
                endIndent: 30,
              ),
              SettingsWidgets(settingsProvider.sortBy),
              Divider(
                color: Colors.grey,
                indent: 30,
                endIndent: 30,
              ),
              SettingsHints(settingsProvider.showHints),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
