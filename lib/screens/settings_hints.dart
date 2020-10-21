import 'package:cogboardmobileapp/models/hints_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsHints extends StatelessWidget {

  final Hints showHints;

  SettingsHints(this.showHints);

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
              "Hints",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Show hints",
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
                  color: showHints == Hints.On ? Colors.blue : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.grey)
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: () {
                    settingsProvider.setShowHints(Hints.On);
                  },
                  child: Text(describeEnum(Hints.On).toString()),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: FlatButton(
                  color: showHints == Hints.Off ? Colors.blue : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.grey)
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: () {
                    settingsProvider.setShowHints(Hints.Off);
                  },
                  child: Text(describeEnum(Hints.Off).toString()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
