import 'package:flutter/material.dart';

enum DashboardType {
  Favorites,
  Quarantine,
  Home
}

class DashboardTab {
  String title;
  final DashboardType dashboardType;
  final Color selectedTabColor;

  DashboardTab({
    this.title,
    @required this.dashboardType,
    @required this.selectedTabColor,
  });
}