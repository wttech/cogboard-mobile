import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/settings_preferences_model.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('settings provider tests', () {

    test('should set show hints', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.createSettingsPreferences();

      // when
      await settingsProvider.setShowHints(false);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.showHints, false);
    });

    test('should set show notifications', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.createSettingsPreferences();

      // when
      await settingsProvider.setShowNotifications(false);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.showNotifications, false);
    });

    test('should set sortBy', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.createSettingsPreferences();

      // when
      await settingsProvider.setSortBy(WidgetSortByKeys.NONE);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.sortBy, WidgetSortByKeys.NONE);
    });

    test('should set current connection', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.createSettingsPreferences();
      ConnectionPreferences currentConnection = new ConnectionPreferences(
        favouriteWidgets: [],
        quarantineWidgets: [],
        connectionName: 'test',
        connectionUrl: 'http://150.254.30.118',
      );

      // when
      await settingsProvider.setCurrentConnection(currentConnection);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.currentConnection.connectionName, currentConnection.connectionName);
    });

    test('should set notification frequency', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.createSettingsPreferences();

      // when
      await settingsProvider.setNotificationsFrequency(5);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.notificationFrequencyInMinutes, 5);
    });

    test('should add new connection', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.fetchSettingsPreferences();
      ConnectionPreferences newConnection = new ConnectionPreferences(
        favouriteWidgets: [],
        quarantineWidgets: [],
        connectionName: 'test',
        connectionUrl: 'http://150.254.30.118',
      );

      // when
      await settingsProvider.addConnection(newConnection);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.connections.length, 1);
      expect(updatedSettingsPreferences.connections.first.connectionName, newConnection.connectionName);
    });

    test('should remove connection', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.fetchSettingsPreferences();
      ConnectionPreferences newConnection = new ConnectionPreferences(
        favouriteWidgets: [],
        quarantineWidgets: [],
        connectionName: 'test',
        connectionUrl: 'http://150.254.30.118',
      );
      await settingsProvider.addConnection(newConnection);
      await settingsProvider.setCurrentConnection(newConnection);

      // when
      await settingsProvider.removeConnection(newConnection);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.connections.isEmpty, true);
    });

    test('should replace connection', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.fetchSettingsPreferences();
      ConnectionPreferences newConnection = new ConnectionPreferences(
        favouriteWidgets: [],
        quarantineWidgets: [],
        connectionName: 'test',
        connectionUrl: 'http://150.254.30.118',
      );
      await settingsProvider.addConnection(newConnection);
      await settingsProvider.setCurrentConnection(newConnection);

      // when
      ConnectionPreferences updatedConnection = new ConnectionPreferences(
        favouriteWidgets: [],
        quarantineWidgets: [],
        connectionName: 'updated',
        connectionUrl: 'http://150.254.30.118',
      );
      await settingsProvider.replaceConnection(updatedConnection, 0);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.connections.first.connectionName != newConnection.connectionName, true);
      expect(updatedSettingsPreferences.connections.first.connectionName, "updated");
    });

    test('should set sortBy key and order', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.createSettingsPreferences();

      // when
      await settingsProvider.setSortByKey(WidgetSortByKeys.STATUS);
      await settingsProvider.setSortByOrder(WidgetSortByOrder.ASC);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.sortBy, WidgetSortByKeys.STATUS + WidgetSortByOrder.ASC);
    });

    test('should fetch settings preferences when they exist', () async {
      // given
      SharedPreferences.setMockInitialValues({});
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.createSettingsPreferences();
      SharedPreferences initialPref = await SharedPreferences.getInstance();
      String initialSettingsPreferences = initialPref.getString(SettingsPreferences.KEY);

      // when
      await settingsProvider.fetchSettingsPreferences();

      // then
      SharedPreferences updatedPref = await SharedPreferences.getInstance();
      expect(updatedPref.getString(SettingsPreferences.KEY), initialSettingsPreferences);
    });
  });
}
