import 'package:flutter/material.dart';

enum SettingsViewMode { List, Tiles }

enum SettingsSortBy { None, Name, Status }

enum SettingsShowHints { On, Off }

class Project {
  final String name;
  final String ipAddress;

  Project({
    @required this.name,
    @required this.ipAddress});
}

class WidgetType {
  final String name;

  WidgetType({
    @required this.name});
}