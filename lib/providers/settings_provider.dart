import 'package:cogboardmobileapp/models/settings_tab.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  final List<Project> _projects =  [
    Project(
      name: 'http://cognifide.com',
      ipAddress: '3.12.192.1'
    ),
    Project(
        name: 'http://hsbc.com',
        ipAddress: '3.122.192.1'
    ),
    Project(
        name: 'http://hsbc.com',
        ipAddress: '3.122.192.1'
    ),
    Project(
        name: 'http://hsbc.com',
        ipAddress: '3.122.192.1'
    ),
    Project(
        name: 'http://hsbc.com',
        ipAddress: '3.122.192.1'
    ),
  ];

  final List<WidgetType> _widgets =  [
    WidgetType(
      name: 'Health Check'
    ),
    WidgetType(
      name: 'Bamboo Plan'
    ),
    WidgetType(
      name: 'Bamboo Deployment'
    ),
    WidgetType(
      name: 'Jenkins'
    ),
    WidgetType(
      name: 'Checkbox'
    ),
    WidgetType(
      name: 'SonarCube'
    ),
    WidgetType(
      name: 'Text Widget'
    ),
    WidgetType(
      name: 'Clock'
    ),
    WidgetType(
      name: 'BundleInfo'
    ),
    WidgetType(
      name: 'ServiceCheck'
    ),
    WidgetType(
      name: 'PersonDraw'
    ),
    WidgetType(
      name: 'IFrame'
    ),
  ];

  List<Project> get projects {
    return _projects;
  }

  List<WidgetType> get widgets {
    return _widgets;
  }

}