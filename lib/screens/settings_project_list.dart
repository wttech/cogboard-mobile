import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_connection_screen.dart';

class SettingsProjectListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 32,
              bottom: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      AppLocalizations.of(context).getTranslation('settingsProjectList.projects'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AddConnectionScreen.routeName,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Column(
            children: settingsProvider.connections.map(
              (project) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Theme.of(context).errorColor,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 40,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                        ),
                        onDismissed: (direction) {
                          settingsProvider.removeConnection(project);
                        },
                        direction: DismissDirection.endToStart,
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 20,
                          child: ListTile(
                            title: Text(
                              project.connectionName,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              project.connectionName,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
