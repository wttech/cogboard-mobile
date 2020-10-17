import 'package:cogboardmobileapp/models/view_mode_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsViewMode extends StatelessWidget {

  final ViewMode viewAs;

  SettingsViewMode(this.viewAs);


  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "View mode",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "View widget as",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  color: viewAs == ViewMode.List ? Colors.blue : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.grey)
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: () {
                    settingsProvider.setViewWidgetsAs(ViewMode.List);
                  },
                  child: Text(describeEnum(ViewMode.List).toString()),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: FlatButton(
                  color: viewAs == ViewMode.Tiles ? Colors.blue : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.grey)
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: () {
                    settingsProvider.setViewWidgetsAs(ViewMode.Tiles);
                  },
                  child: Text(describeEnum(ViewMode.Tiles).toString()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
