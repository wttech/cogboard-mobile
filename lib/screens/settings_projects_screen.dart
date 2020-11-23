import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/add_connection_screen.dart';
import 'package:cogboardmobileapp/screens/login_screen.dart';
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
        title: Text('Projects'),
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
        content: Text('Are you sure?'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'NO',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              settingsProvider.removeConnection(connection);
              if (settingsProvider.connections.length == 0) {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'YES',
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
