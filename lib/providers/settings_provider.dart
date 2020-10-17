import 'package:cogboardmobileapp/models/connection_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  final SharedPref _sharedPref = new SharedPref();
  List<Connection> _connections;

  // SettingsProvider() {
  //   loadConenctions();
  // }

  Future<void> fetchConnections() async {
    _connections =
        Connection.decodeConnections(await _sharedPref.read('connections'));
    notifyListeners();
  }

  List<Connection> get connections {
    return _connections;
  }
}
