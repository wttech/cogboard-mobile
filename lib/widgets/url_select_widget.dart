import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/login_projects_screen.dart';
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
            color: Colors.black54,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(STANDARD_BORDER_RADIOUS),
          ),
        ),
        child: RaisedButton(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: Colors.white,
          elevation: 0,
          onPressed: () => Navigator.of(context).pushNamed(LoginProjectsScreen.routeName),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                settingsProvider.currentConnection.connectionName.length > 13
                    ? settingsProvider.currentConnection.connectionName.substring(0, 10) + "..."
                    : settingsProvider.currentConnection.connectionName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.cyan,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Text(
          AppLocalizations.of(context).getTranslation('urlSelect.noConnections'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
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
