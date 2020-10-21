import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsWidgets extends StatelessWidget {

  final WidgetSortBy sortBy;

  final List<WidgetType> widgetTypes;
  SettingsWidgets(this.widgetTypes, this.sortBy);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Widgets",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Sort by",
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
                  color: sortBy == WidgetSortBy.None ? Colors.blue : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.grey)
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: () {
                    settingsProvider.setWidgetsSortBy(WidgetSortBy.None);
                  },
                  child: Text(describeEnum(WidgetSortBy.None).toString()),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: FlatButton(
                  color: sortBy == WidgetSortBy.Name ? Colors.blue : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.grey)
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: () {
                    settingsProvider.setWidgetsSortBy(WidgetSortBy.Name);
                  },
                  child: Text(describeEnum(WidgetSortBy.Name).toString()),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: FlatButton(
                  color: sortBy == WidgetSortBy.Status ? Colors.blue : Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.grey)
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  onPressed: () {
                    settingsProvider.setWidgetsSortBy(WidgetSortBy.Status);
                  },
                  child: Text(describeEnum(WidgetSortBy.Status).toString()),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              "Visible widgets types",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
          Column(
            children: widgetTypes.map((widget) {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: SwitchListTile(
                      title: Text(
                        widget.name,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      value: widgetTypes[widgetTypes.indexOf(widget)].isVisible,
                      onChanged: (bool value) {
                        settingsProvider.setWidgetTypeVisible(widgetTypes.indexOf(widget), value);
                      },
                      activeColor: Colors.blue,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
