import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/add_connection_screen.dart';
import 'package:cogboardmobileapp/screens/dashboards_screen.dart';
import 'package:cogboardmobileapp/screens/login_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginProjectsScreen extends StatelessWidget {
  static const routeName = '/login/projects';

  const LoginProjectsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).getTranslation('settingsProjectsScreen.title'),
        ),
      ),
      body: ListView.separated(
        itemCount: settingsProvider.connections.length,
        itemBuilder: (context, idx) {
          ConnectionPreferences connection = settingsProvider.connections[idx];
          return ListTile(
            title: settingsProvider.currentConnection.connectionName == connection.connectionName
                ? Text(
              connection.connectionName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
                : Text(connection.connectionName),
            subtitle: Text(connection.connectionUrl),
            onTap: () {
              settingsProvider.setCurrentConnection(connection);
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 2,
          );
        },
      ),
    );
  }
}
