import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  // TODO: #13, #14
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
