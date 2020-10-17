import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/settings_hints.dart';
import 'package:cogboardmobileapp/screens/settings_project_list.dart';
import 'package:cogboardmobileapp/screens/settings_view_mode.dart';
import 'package:cogboardmobileapp/screens/settings_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  // TODO: #13, #14
  @override
  Widget build(BuildContext context) {
//    final settingsProvider = Provider.of<SettingsProvider>(context);
//    final settingsProjects = settingsProvider.connections;
//    final widgetProjects = settingsProvider.widgets;

//    settingsProvider.initialValue();

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: FutureBuilder(
          future: Provider.of<SettingsProvider>(context, listen: false).fetchSettingsConfig(),
          builder: (ctx, dataSnapshot) {
            return Consumer<SettingsProvider>(builder: (ctx, settingsProvider, child) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: LayoutBuilder(builder: (ctx, constrains) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                            ),
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
//                      SizedBox(
//                        width: constrains.maxWidth * 0.50,
//                      ),
                                Container(
//                        width: constrains.maxWidth * 0.3,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                      SettingsProjectListScreen(settingsProvider.connections),
                      Divider(
                        color: Colors.grey,
                        indent: 30,
                        endIndent: 30,
                      ),
                      SettingsViewMode(settingsProvider.viewAs),
                      Divider(
                        color: Colors.grey,
                        indent: 30,
                        endIndent: 30,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          margin: EdgeInsets.only(bottom: 20),
                          child: SettingsWidgets(settingsProvider.widgets)),
                      Divider(
                        color: Colors.grey,
                        indent: 30,
                        endIndent: 30,
                      ),
                      SettingsHints(),
                      Divider(
                        color: Colors.grey,
                        indent: 30,
                        endIndent: 30,
                      ),
                    ],
                  ),
                ),
              );
            });
          }),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
