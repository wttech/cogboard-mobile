import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/widgets/settings_sort_by_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsSortBy extends StatelessWidget {
  const SettingsSortBy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    bool noneCheck = false;
    bool nameCheck = false;
    bool statusCheck = false;
    bool ascCheck = false;
    bool descCheck = false;

    if (settingsProvider.sortByKey == WidgetSortByKeys.NONE) {
      noneCheck = true;
    } else if (settingsProvider.sortByKey == WidgetSortByKeys.NAME) {
      nameCheck = true;
    } else if (settingsProvider.sortByKey == WidgetSortByKeys.STATUS) {
      statusCheck = true;
    }

    if (settingsProvider.sortByOrder == WidgetSortByOrder.ASC) {
      ascCheck = true;
    } else if (settingsProvider.sortByOrder == WidgetSortByOrder.DESC) {
      descCheck = true;
    }

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                child: Text(
                  AppLocalizations.of(context).getTranslation('settingsSortByWidget.sortBy'),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          SettingsSortByOption(
            name: AppLocalizations.of(context).getTranslation('settingsSortByWidget.none'),
            onTap: () => settingsProvider.setSortByKey(WidgetSortByKeys.NONE),
            check: noneCheck,
          ),
          SettingsSortByOption(
            name: AppLocalizations.of(context).getTranslation('settingsSortByWidget.name'),
            onTap: () => settingsProvider.setSortByKey(WidgetSortByKeys.NAME),
            check: nameCheck,
          ),
          SettingsSortByOption(
            name: AppLocalizations.of(context).getTranslation('settingsSortByWidget.status'),
            onTap: () => settingsProvider.setSortByKey(WidgetSortByKeys.STATUS),
            check: statusCheck,
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                child: Text(
                  AppLocalizations.of(context).getTranslation('settingsSortByWidget.order'),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          SettingsSortByOption(
            name: AppLocalizations.of(context).getTranslation('settingsSortByWidget.asc'),
            onTap: () => settingsProvider.setSortByOrder(WidgetSortByOrder.ASC),
            check: ascCheck,
          ),
          SettingsSortByOption(
            name: AppLocalizations.of(context).getTranslation('settingsSortByWidget.desc'),
            onTap: () => settingsProvider.setSortByOrder(WidgetSortByOrder.DESC),
            check: descCheck,
          ),
        ],
      ),
    );
  }
}
