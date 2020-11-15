import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsWidgets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    double arrowIconSize = 15.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              AppLocalizations.of(context).getTranslation('settingsSortBy.widgets'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              AppLocalizations.of(context).getTranslation('settingsSortBy.sortBy'),
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
                  color: settingsProvider.sortBy == WidgetSortTypes.NONE
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS), side: BorderSide(color: Colors.grey)),
                  textColor: settingsProvider.sortBy == WidgetSortTypes.NONE
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  splashColor: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    settingsProvider.setSortBy(WidgetSortTypes.NONE);
                  },
                  child: Text(AppLocalizations.of(context).getTranslation('settingsSortBy.none')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: FlatButton(
                  color: (settingsProvider.sortBy == WidgetSortTypes.NAME_ASCENDING ||
                          settingsProvider.sortBy == WidgetSortTypes.NAME_DESCENDING)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS), side: BorderSide(color: Colors.grey)),
                  textColor: (settingsProvider.sortBy == WidgetSortTypes.NAME_ASCENDING ||
                          settingsProvider.sortBy == WidgetSortTypes.NAME_DESCENDING)
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  splashColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    if (settingsProvider.sortBy == WidgetSortTypes.NAME_DESCENDING) {
                      settingsProvider.setSortBy(WidgetSortTypes.NAME_ASCENDING);
                    } else if (settingsProvider.sortBy == WidgetSortTypes.NAME_ASCENDING) {
                      settingsProvider.setSortBy(WidgetSortTypes.NAME_DESCENDING);
                    } else {
                      settingsProvider.setSortBy(WidgetSortTypes.NAME_DESCENDING);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).getTranslation('settingsSortBy.name')),
                      settingsProvider.sortBy == WidgetSortTypes.NAME_ASCENDING
                          ? Icon(
                              Icons.arrow_upward,
                              size: arrowIconSize,
                            )
                          : Icon(
                              Icons.arrow_downward,
                              size: arrowIconSize,
                            )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
              Expanded(
                child: FlatButton(
                  color: (settingsProvider.sortBy == WidgetSortTypes.STATUS_ASCENDING ||
                          settingsProvider.sortBy == WidgetSortTypes.STATUS_DESCENDING)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                    side: BorderSide(color: Colors.grey),
                  ),
                  textColor: (settingsProvider.sortBy == WidgetSortTypes.STATUS_ASCENDING ||
                          settingsProvider.sortBy == WidgetSortTypes.STATUS_DESCENDING)
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                  splashColor: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (settingsProvider.sortBy == WidgetSortTypes.STATUS_DESCENDING) {
                      settingsProvider.setSortBy(WidgetSortTypes.STATUS_ASCENDING);
                    } else if (settingsProvider.sortBy == WidgetSortTypes.STATUS_ASCENDING) {
                      settingsProvider.setSortBy(WidgetSortTypes.STATUS_DESCENDING);
                    } else {
                      settingsProvider.setSortBy(WidgetSortTypes.STATUS_DESCENDING);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).getTranslation('settingsSortBy.status')),
                      settingsProvider.sortBy == WidgetSortTypes.STATUS_ASCENDING
                          ? Icon(
                              Icons.arrow_upward,
                              size: arrowIconSize,
                            )
                          : Icon(
                              Icons.arrow_downward,
                              size: arrowIconSize,
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
