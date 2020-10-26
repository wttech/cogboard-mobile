import 'package:cogboardmobileapp/models/connection_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsProjectListScreen extends StatelessWidget {
  final List<Connection> projects;

  SettingsProjectListScreen(this.projects);

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
                      "Projects",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Column(
            children: projects.map(
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
                        onDismissed: (direction){
                          settingsProvider.removeConnection(project);
                        },
                        direction: DismissDirection.endToStart,
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 20,
                          child: ListTile(
                            title: Text(
                              project.name,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              project.name,
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
