import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/settings_preferences_model.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  List<ConnectionPreferences> _connections;
  SettingsPreferences _settingsPreferences;

  get settingsPreferences => _settingsPreferences;

  get showHints => _settingsPreferences.showHints;

  get showNotifications => _settingsPreferences.showNotifications;

  get notificationsFrequency => _settingsPreferences.notificationFrequencyInMinutes;

  get sortBy => _settingsPreferences.sortBy;

  get sortByKey => _settingsPreferences.sortByKey;

  get sortByOrder => _settingsPreferences.sortByOrder;

  Future<void> fetchSettingsPreferences() async {
    if (await SharedPref.containsKey(SettingsPreferences.KEY)) {
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(await SharedPref.read(SettingsPreferences.KEY));
      int settingsPreferencesVersion = SettingsPreferences.readVersion(settingsPreferencesJson);
      if (settingsPreferencesVersion == null ||
          (settingsPreferencesVersion != null && settingsPreferencesVersion < SettingsPreferences.VERSION)) {
        await createSettingsPreferences();
      } else {
        _settingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      }
    } else {
      await createSettingsPreferences();
    }
    _connections = _settingsPreferences.connections;
  }

  Future<void> createSettingsPreferences() async {
    _settingsPreferences = new SettingsPreferences(
      connections: [],
      version: SettingsPreferences.VERSION,
      showHints: true,
      sortBy: WidgetSortTypes.NONE,
      showNotifications: true,
      hints: SettingsPreferences.createHints(),
      notificationFrequencyInMinutes: 1,
      sortByKey: WidgetSortByKeys.NONE,
      sortByOrder: WidgetSortByOrder.DESC,
    );
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
  }

  List<ConnectionPreferences> get connections {
    return _connections;
  }

  ConnectionPreferences get currentConnection {
    return _settingsPreferences.currentConnection;
  }

  T enumFromString<T>(Iterable<T> values, String value) {
    return values.firstWhere((type) => type.toString().split(".").last == value, orElse: () => null);
  }

  Future<void> setShowHints(bool showHints) async {
    _settingsPreferences.showHints = showHints;
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> setShowNotifications(bool showNotifications) async {
    _settingsPreferences.showNotifications = showNotifications;
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> setSortBy(String sortBy) async {
    _settingsPreferences.sortBy = sortBy;
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> setCurrentConnection(ConnectionPreferences currentConnection) async {
    _settingsPreferences.currentConnection = currentConnection;
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> setNotificationsFrequency(int notificationFrequency) async {
    _settingsPreferences.notificationFrequencyInMinutes = notificationFrequency;
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> addConnection(ConnectionPreferences connection) async {
    _connections.add(connection);
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> removeConnection(ConnectionPreferences connection) async {
    _connections.remove(connection);
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> replaceConnection(ConnectionPreferences newConnection, int idx) async {
    _connections[idx] = newConnection;
    notifyListeners();
  }

  Future<void> setSortByOrder(String order) async {
    _settingsPreferences.sortByOrder = order;
    if (_settingsPreferences.sortByKey != WidgetSortByKeys.NONE) {
      setSortBy(_settingsPreferences.sortByKey + order);
    }
    notifyListeners();
  }

  Future<void> setSortByKey(String key) async {
    _settingsPreferences.sortByKey = key;
    if (key == WidgetSortByKeys.NONE) {
      setSortBy(WidgetSortByKeys.NONE);
    } else {
      setSortBy(key + _settingsPreferences.sortByOrder);
    }
    notifyListeners();
  }
}
