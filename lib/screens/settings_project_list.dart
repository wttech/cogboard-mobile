import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cogboardmobileapp/models/settings_tab.dart';

class SettingsProjectListScreen extends StatelessWidget {
  final List<Project> projects;

  SettingsProjectListScreen(this.projects);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: projects.map(
          (project) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 7),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Text(
                      project.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
