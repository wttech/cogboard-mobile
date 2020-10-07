import 'package:flutter/material.dart';

enum DashboardTabId {
  Favorites,
  Quarantine,
  Home,
  Error,
  Warning
}

class DashboardTab {
  final Widget page;
  final String title;
  final DashboardTabId dashboardTabId;
  final Color selectedTabColor;

  DashboardTab({
    @required this.page,
    @required this.title,
    @required this.dashboardTabId,
    @required this.selectedTabColor,
  });
}