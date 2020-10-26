import 'package:cogboardmobileapp/models/connection_model.dart';
import 'package:cogboardmobileapp/models/hints_model.dart';
import 'package:cogboardmobileapp/models/widget_sort_by_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  WidgetSortBy _sortBy;
  Hints _showHints;
  bool _settingsConfigFetched = false;
  List<Connection> _connections;
  Connection _currentConnection;

  List<Connection> get connections {
    return _connections;
  }

  WidgetSortBy get sortBy {
    return _sortBy;
  }

  Hints get showHints {
    return _showHints;
  }

  Connection get currentConnection {
    return _currentConnection;
  }

  initialValue() async {
    SharedPref.save('connections', _connections);
    WidgetSortBy sortBy = WidgetSortBy.Name;
    SharedPref.save('widgetsSortBy', describeEnum(sortBy).toString());
    Hints showHints = Hints.Off;
    SharedPref.save('showHints', describeEnum(showHints).toString());
  }

  T enumFromString<T>(Iterable<T> values, String value) {
    return values.firstWhere((type) => type.toString().split(".").last == value, orElse: () => null);
  }

  Future<void> fetchWidgetsSortBy() async {
    if(await SharedPref.containsKey('widgetsSortBy')) {
      _sortBy = enumFromString(WidgetSortBy.values, await SharedPref.read('widgetsSortBy'));
    } else {
      _sortBy = WidgetSortBy.None;
    }
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

  Future<void> fetchShowHints() async {
    if(await SharedPref.containsKey('showHints')) {
      _showHints = enumFromString(Hints.values, await SharedPref.read('showHints'));
    } else {
      _showHints = Hints.On;
    }
    notifyListeners();
  }

  Future<void> fetchSettingsConfig() async {
    if (!_settingsConfigFetched) {
      await fetchConnections();
      await fetchWidgetsSortBy();
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

  setWidgetsSortBy(WidgetSortBy widgetSortBy) {
    _sortBy = widgetSortBy;
    SharedPref.save('widgetsSortBy', describeEnum(_sortBy).toString());
    notifyListeners();
  }

  setShowHints(Hints newShowHints) {
    _showHints = newShowHints;
    SharedPref.save('showHints', describeEnum(_showHints).toString());
    notifyListeners();
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
