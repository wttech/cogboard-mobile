import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/add_connection_screen.dart';
import 'package:cogboardmobileapp/screens/login_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsProjectsScreen extends StatelessWidget {
  static const routeName = '/settings/projects';

  const SettingsProjectsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).getTranslation('settingsProjectsScreen.title'),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pushNamed(AddConnectionScreen.routeName),
            child: Text(
              '+',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: settingsProvider.connections
            .map(
              (connection) => ListTile(
                title: Text(connection.connectionName),
                subtitle: Text(connection.connectionUrl),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => onDeletePressed(context, connection),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddConnectionScreen(
                      editMode: true,
                      connection: connection,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void onDeletePressed(BuildContext context, ConnectionPreferences connection) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          AppLocalizations.of(context).getTranslation('settingsProjectsScreen.alert.title'),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context).getTranslation('settingsProjectsScreen.alert.decline'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          FlatButton(
            onPressed: () async {
              await settingsProvider.removeConnection(connection);
              if (settingsProvider.currentConnection == null) {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              AppLocalizations.of(context).getTranslation('settingsProjectsScreen.alert.confirm'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
