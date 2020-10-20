import 'package:cogboardmobileapp/models/connection_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  // final SharedPref _sharedPref = new SharedPref();
  List<Connection> _connections;
  Connection _currentConnection;

  Future<void> fetchConnections() async {
    if (await SharedPref.containsKey('connections')) {
      _connections =
          Connection.decodeConnections(await SharedPref.read('connections'));
    } else {
      _connections = List();
    }
    notifyListeners();
  }

  List<Connection> get connections {
    return _connections;
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
