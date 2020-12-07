import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UrlSelect extends StatelessWidget {
  final String newlyAddedConnection;

  UrlSelect({this.newlyAddedConnection});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    List<ConnectionPreferences> connections = settingsProvider.connections;
    if (connections != null && connections.length > 0) {
      return Container(
        width: 150,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(STANDARD_BORDER_RADIOUS),
          ),
        ),
        child: new DropdownButton<int>(
          value: getDropdownButtonIndex(newlyAddedConnection, settingsProvider),
          underline: Container(),
          isExpanded: true,
          items: connections.map((ConnectionPreferences connection) {
            return new DropdownMenuItem(
              child: new Text(connection.connectionName),
              value: connections.indexOf(connection),
            );
          }).toList(),
          onChanged: (currentConnection) => settingsProvider.setCurrentConnection(connections[currentConnection]),
        ),
      );
    } else {
      return Container(
        child: Text(
          AppLocalizations.of(context).getTranslation('urlSelect.noConnections'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      );
    }
  }

  int getDropdownButtonIndex(String newlyAddedConnection, SettingsProvider settingsProvider) {
    if (settingsProvider.currentConnection != null) {
      ConnectionPreferences currentConnection = settingsProvider.connections
          .firstWhere((element) => element.connectionName == settingsProvider.currentConnection.connectionName);
      return settingsProvider.connections.indexOf(currentConnection);
    }
    return null;
  }
}
