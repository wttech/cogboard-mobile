import 'package:cogboardmobileapp/models/connection_model.dart';
import 'package:cogboardmobileapp/models/hints_model.dart';
import 'package:cogboardmobileapp/models/view_mode_model.dart';
import 'package:cogboardmobileapp/models/widget_type_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  WidgetSortBy _sortBy;
  ViewMode _viewAs;
  Hints _showHints;
  bool _settingsConfigFetched = false;
  List<Connection> _connections;
  Connection _currentConnection;

//  final List<Connection> _connections = [
//    Connection(url: 'http://cognifide.com', name: 'Cogboard', isActive: false),
//    Connection(url: 'http://cognifide.com', name: 'HSBC', isActive: false),
//    Connection(url: 'http://cognifide.com', name: 'Douglas', isActive: false),
//    Connection(url: 'http://cognifide.com', name: 'EY', isActive: false),
//    Connection(url: 'http://cognifide.com', name: 'Coutts', isActive: false),
//  ];

  final List<WidgetType> _widgetTypes = [
    WidgetType(
      name: 'Health Check',
      isVisible: true,
    ),
    WidgetType(name: 'Bamboo Plan', isVisible: true),
    WidgetType(name: 'Bamboo Deployment', isVisible: true),
    WidgetType(name: 'Jenkins', isVisible: true),
    WidgetType(name: 'Checkbox', isVisible: true),
    WidgetType(name: 'SonarCube', isVisible: true),
    WidgetType(name: 'Text Widget', isVisible: true),
    WidgetType(name: 'Clock', isVisible: true),
    WidgetType(name: 'BundleInfo', isVisible: true),
    WidgetType(name: 'ServiceCheck', isVisible: true),
    WidgetType(name: 'PersonDraw', isVisible: true),
    WidgetType(name: 'IFrame', isVisible: true),
  ];

  List<WidgetType> get widgets {
    return _widgetTypes;
  }

  List<Connection> get connections {
    return _connections;
  }

  ViewMode get viewMode {
    return _viewAs;
  }

  WidgetSortBy get sortBy {
    return _sortBy;
  }

  Hints get showHints {
    return _showHints;
  }

  initialValue() async {
    SharedPref.save('connections', _connections);
    ViewMode viewWidgetAs = ViewMode.List;
    SharedPref.save('viewAs', describeEnum(viewWidgetAs).toString());
    SharedPref.save('widgetsTypes', _widgetTypes);
    WidgetSortBy sortBy = WidgetSortBy.Name;
    SharedPref.save('widgetsSortBy', describeEnum(sortBy).toString());
    Hints showHints = Hints.Off;
    SharedPref.save('showHints', describeEnum(showHints).toString());
  }

  T enumFromString<T>(Iterable<T> values, String value) {
    return values.firstWhere((type) => type.toString().split(".").last == value, orElse: () => null);
  }

  Future<void> fetchViewWidgetsAs() async {
    _viewAs = enumFromString(ViewMode.values, await SharedPref.read('viewAs'));
    print(_viewAs.toString());
  }

  Future<void> fetchWidgetsSortBy() async {
    _sortBy = enumFromString(WidgetSortBy.values, await SharedPref.read('widgetsSortBy'));
  }

  Future<void> fetchWidgetsTypes() async {
    List<WidgetType> allWidgetsTypes =
        (await SharedPref.read('widgetsTypes') as List).map((widgetType) => WidgetType.fromJson(widgetType)).toList();

    for (var con in allWidgetsTypes) {
      print(con.name);
    }
  }

  Future<void> fetchShowHints() async {
    _showHints = enumFromString(Hints.values, await SharedPref.read('showHints'));
    print(_showHints.toString());
  }

  Future<void> fetchSettingsConfig() async {
    if (!_settingsConfigFetched) {
      await fetchConnections();
      await fetchViewWidgetsAs();
      await fetchWidgetsSortBy();
      await fetchWidgetsTypes();
      await fetchShowHints();
      _settingsConfigFetched = true;
      notifyListeners();
    }
  }

  void addNewConnection(Connection newConnection) {
    _connections.add(newConnection);
    SharedPref.save('connections', _connections);
    notifyListeners();
  }

  void removeConnection(Connection removedConnection) {
    _connections.remove(removedConnection);
    SharedPref.save('connections', _connections);
    notifyListeners();
  }

  setViewWidgetsAs(ViewMode viewWidgetAs) {
    _viewAs = viewWidgetAs;
    SharedPref.save('viewAs', describeEnum(_viewAs).toString());
    notifyListeners();
  }

  setWidgetsSortBy(WidgetSortBy widgetSortBy) {
    _sortBy = widgetSortBy;
    SharedPref.save('viewAs', describeEnum(_sortBy).toString());
    notifyListeners();
  }

  setWidgetTypeVisible(int index, bool value) {
    _widgetTypes[index].isVisible = value;
    SharedPref.save('widgetsTypes', _widgetTypes);
    notifyListeners();
  }

  setShowHints(Hints newShowHints) {
    _showHints = newShowHints;
    SharedPref.save('showHints', describeEnum(_showHints).toString());
    notifyListeners();
  }
  Future<void> fetchConnections() async {
    if (await SharedPref.containsKey('connections')) {
      _connections =
          Connection.decodeConnections(await SharedPref.read('connections'));
    } else {
      _connections = List();
    }
    notifyListeners();
  }

  Connection get currentConnection {
    return _currentConnection;
  }

  void setCurrentConnection(Connection c) {
    _currentConnection = c;
    // TODO set lastVisited = true to corresponding connection in _connections
    notifyListeners();
  }

  void addConnection(Connection c) async {
    _connections.add(c);
    await SharedPref.save(
        'connections', Connection.encodeConnections(_connections));
    notifyListeners();
  }
}
