import 'package:cogboardmobileapp/constants/constants.dart';
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
                  color: showHints == Hints.On
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(standardBorderRadius),
                      side: BorderSide(color: Colors.grey)),
                  textColor: showHints == Hints.On
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onBackground,
                  splashColor: Theme.of(context).colorScheme.primary,
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
                  color: showHints == Hints.Off
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(standardBorderRadius),
                      side: BorderSide(color: Colors.grey)),
                  textColor: showHints == Hints.Off
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onBackground,
                  splashColor: Theme.of(context).colorScheme.primary,
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
