import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

enum DashboardType {
  Favourites,
  Quarantine,
  Home
}

class DashboardTab {
  final DashboardType dashboardType;
  final Color selectedTabColor;

  DashboardTab({
    @required this.dashboardType,
    @required this.selectedTabColor,
  });

  getTitle(BuildContext context) {
    return  AppLocalizations.of(context).getTranslation("dashboardsProvider.${EnumToString.convertToString(dashboardType)}");
  }
}