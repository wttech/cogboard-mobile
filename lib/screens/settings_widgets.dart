import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/widget_type_model.dart';
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
                color: Theme.of(context).colorScheme.onBackground,
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
                  color: sortBy == WidgetSortBy.None
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(standardBorderRadius),
                      side: BorderSide(color: Colors.grey)),
                  textColor: sortBy == WidgetSortBy.None
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  splashColor: Theme.of(context).colorScheme.primary,
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
                  color: sortBy == WidgetSortBy.Name
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(standardBorderRadius),
                      side: BorderSide(color: Colors.grey)),
                  textColor: sortBy == WidgetSortBy.Name
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  splashColor: Theme.of(context).colorScheme.onPrimary,
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
                  color: sortBy == WidgetSortBy.Status
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(standardBorderRadius),
                    side: BorderSide(color: Colors.grey),
                  ),
                  textColor: sortBy == WidgetSortBy.Status
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  splashColor: Theme.of(context).colorScheme.primary,
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
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      value: widgetTypes[widgetTypes.indexOf(widget)].isVisible,
                      onChanged: (bool value) {
                        settingsProvider.setWidgetTypeVisible(
                            widgetTypes.indexOf(widget), value);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
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
