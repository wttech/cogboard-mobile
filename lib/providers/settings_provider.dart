import 'dart:io';
import 'dart:convert';

import 'package:cogboardmobileapp/models/connection_model.dart';
import 'package:cogboardmobileapp/models/hints_model.dart';
import 'package:cogboardmobileapp/models/view_mode_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {

  WidgetSortBy sortBy;
  ViewMode viewAs;
  Hints showHints;
  bool settingsConfigFetched = false;




  final List<Connection> _connections =  [
    Connection(
      url: 'http://cognifide.com',
      name: 'Cogboard',
      isActive: false
    ),
    Connection(
        url: 'http://cognifide.com',
        name: 'HSBC',
      isActive: false
    ),
    Connection(
        url: 'http://cognifide.com',
        name: 'Douglas',
      isActive: false
    ),
    Connection(
        url: 'http://cognifide.com',
        name: 'EY',
      isActive: false
    ),
    Connection(
        url: 'http://cognifide.com',
        name: 'Coutts',
      isActive: false
    ),
  ];
  final SharedPref _sharedPref = new SharedPref();
//  List<Connection> _connections;

  final List<WidgetType> _widgets =  [
    WidgetType(
      name: 'Health Check',
      isVisible: true,
    ),
    WidgetType(
      name: 'Bamboo Plan',
        isVisible: true
    ),
    WidgetType(
      name: 'Bamboo Deployment',
        isVisible: true
    ),
    WidgetType(
      name: 'Jenkins',
        isVisible: true
    ),
    WidgetType(
      name: 'Checkbox',
        isVisible: true
    ),
    WidgetType(
      name: 'SonarCube',
        isVisible: true
    ),
    WidgetType(
      name: 'Text Widget',
        isVisible: true
    ),
    WidgetType(
      name: 'Clock',
        isVisible: true
    ),
    WidgetType(
      name: 'BundleInfo',
        isVisible: true
    ),
    WidgetType(
      name: 'ServiceCheck',
        isVisible: true
    ),
    WidgetType(
      name: 'PersonDraw',
        isVisible: true
    ),
    WidgetType(
      name: 'IFrame',
        isVisible: true
    ),
  ];

  List<WidgetType> get widgets {
    return _widgets;
  }

  // SettingsProvider() {
  //   loadConenctions();
  // }

//  Future<void> fetchConnections() async {
//    _connections =
//        Connection.decodeConnections(await _sharedPref.read('connections'));
//    notifyListeners();
//  }
//
  List<Connection> get connections {
    return _connections;
  }

  initialValue() async {

    _sharedPref.save('connections', _connections);
    _sharedPref.save('widgetsTypes', _widgets);
    WidgetSortBy sortBy = WidgetSortBy.Name;
    _sharedPref.save('widgetsSortBy', describeEnum(sortBy).toString());
    ViewMode viewAs = ViewMode.List;
    _sharedPref.save('viewAs', describeEnum(viewAs).toString());
    Hints showHints = Hints.Off;
    _sharedPref.save('showHints', describeEnum(showHints).toString());


  }

  T enumFromString<T>(Iterable<T> values, String value) {
    return values.firstWhere((type) => type.toString().split(".").last == value,
        orElse: () => null);
  }

  Future<void> fetchConnections() async {
    List<Connection> allConnections = (await _sharedPref.read(
        'connections') as List).map((connection) =>
        Connection.fromJson(connection)).toList();

    for (var con in allConnections) {
      print(con.name);
    }
  }

  void addNewConnection(Connection newConnection) {
    _connections.add(newConnection);
    _sharedPref.save('connections', _connections);
    notifyListeners();
  }

  void removeConnection(Connection removedConnection) {
    _connections.remove(removedConnection);
    _sharedPref.save('connections', _connections);
    notifyListeners();
  }

  Future<void> fetchViewWidgetsAs() async {
    viewAs = enumFromString(ViewMode.values, await _sharedPref.read('viewAs'));
    print(viewAs.toString());
  }

  Future<void> fetchSettingsConfig() async {
    if(!settingsConfigFetched) {
      await fetchConnections();
      await fetchWidgetsTypes();
      await fetchWidgetsSortBy();
      await fetchViewWidgetsAs();
      await fetchShowHints();
      settingsConfigFetched = true;
      notifyListeners();
    }
  }

  setViewWidgetsAs(ViewMode viewWidgetAs) {
    viewAs = viewWidgetAs;
    _sharedPref.save('viewAs', describeEnum(viewAs).toString());
    notifyListeners();
  }

  ViewMode get ViewModeAs{
    return viewAs;
  }

  Future<void> fetchWidgetsSortBy() async {
    sortBy = enumFromString(WidgetSortBy.values, await _sharedPref.read('widgetsSortBy'));
  }

  setWidgetsSortBy(WidgetSortBy widgetSortBy) {
    sortBy = widgetSortBy;
    _sharedPref.save('viewAs', describeEnum(sortBy).toString());
    notifyListeners();
  }


  Future<void> fetchWidgetsTypes() async {
    List<WidgetType> allWidgetsTypes = (await _sharedPref.read(
        'widgetsTypes') as List).map((widgetType) =>
        WidgetType.fromJson(widgetType)).toList();

    for (var con in allWidgetsTypes) {
      print(con.name);
    }
  }

  setWidgetTypeVisible(int index, bool value){
    _widgets[index].isVisible = value;
    _sharedPref.save('widgetsTypes', _widgets);
    notifyListeners();
  }

  Future<void> fetchShowHints() async {
    showHints = enumFromString(Hints.values, await _sharedPref.read('showHints'));
    print(showHints.toString());
  }

  setShowHints(Hints newShowHints) {
    showHints = newShowHints;
    _sharedPref.save('showHints', describeEnum(showHints).toString());
    notifyListeners();
  }




}
