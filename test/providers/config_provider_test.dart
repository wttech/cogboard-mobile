import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/settings_preferences_model.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('config provider tests', () {

    test('should settings preferences be set correctly', () async {
      // given
      SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();

      // when
      ConfigProvider configProvider = new ConfigProvider();
      configProvider = configProvider.withSettingsPreferences(settingsPreferences);

      // then
      expect(configProvider.showNotifications, false);
      expect(configProvider.showHints, true);
      expect(configProvider.notificationFrequency, 1);
      expect(configProvider.hints, {
        Hints.REFRESH_FETCHING_CONFIG: true,
        Hints.SWIPE_BOARDS: true,
        Hints.SWIPE_WIDGET_DETAILS: true,
        Hints.SWIPE_TO_DELETE: true
      });
    });

    test('should fetch config', () async {
      //given
      SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
      ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);

      // when
      await configProvider.fetchConfig();

      // then
      expect(configProvider.boards.length, 1);
      expect(configProvider.boards[0].title, "TestBoard 1");
    });

    group('widgetStatusSortValue tests', () {
      widgetStatusSortValueParameters().forEach((element) {
        String sortingKey = element.keys.first;
        test('should sort by $sortingKey', () async {
          // given
          SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
          ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);
          await configProvider.fetchConfig();
          configProvider.setCurrentBoard(configProvider.boards[0]);
          settingsPreferences.sortBy = sortingKey;
          configProvider = configProvider.withSettingsPreferences(settingsPreferences);

          // when
          List<DashboardWidget> sortedWidgets = configProvider.getBoardWidgets(configProvider.currentBoard);

          // then
          List<String> sortedWidgetIds = sortedWidgets.map((e) => e.id).toList();
          expect(sortedWidgetIds, element[sortingKey]);
        });
      });
    });

    group('isErrorWidgetStatus tests', () {
      isErrorWidgetStatusParameters().forEach((element) {
        WidgetStatus widgetStatus = element.keys.first;
        test('should detect error widget status for $widgetStatus', () async {
          // given
          ConfigProvider configProvider = new ConfigProvider();

          // when
          bool errorWidgetStatus = configProvider.isErrorWidgetStatus(widgetStatus);

          // then
          expect(errorWidgetStatus,element[widgetStatus]);
        });
      });
    });

    group('shouldNotify tests', () {

      test('should not notify when show notification disabled in preferences', () async {
        // given
        SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
        settingsPreferences.showNotifications = false;
        ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);

        // when
        bool shouldNotify = configProvider.shouldNotify();

        // then
        expect(shouldNotify, false);
      });

      test('should not notify when not enough time has passed', () async {
        // given
        SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
        settingsPreferences.showNotifications = true;
        settingsPreferences.lastNotificationTimestamp = new DateTime.now();
        ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);

        // when
        bool shouldNotify = configProvider.shouldNotify();

        // then
        expect(shouldNotify, false);
      });

      test('should not notify when widgets are in quarantine', () async {
        // given
        SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
        settingsPreferences.showNotifications = true;
        settingsPreferences.lastNotificationTimestamp = new DateTime.now().subtract(new Duration(minutes: 5));
        ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);
        await configProvider.fetchConfig();
        configProvider.getAllWidgets().forEach((element) {
          configProvider.addQuarantineWidget(element);
        });

        // when
        bool shouldNotify = configProvider.shouldNotify();

        // then
        expect(shouldNotify, false);
      });

      test('should notify when widget state change to error state', () async {
        // given
        SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
        settingsPreferences.showNotifications = true;
        settingsPreferences.lastNotificationTimestamp = new DateTime.now().subtract(new Duration(minutes: 5));
        ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);
        await configProvider.fetchConfig();
        String updatedWidget10DataString = "{\r\n        \"id\": \"widget10\",\r\n        \"title\": \"PL\",\r\n        \"config\": {"
            "\r\n          \"columns\": 2,\r\n          \"goNewLine\": false,\r\n          \"rows\": 0.5\r\n        },"
            "\r\n        \"type\": \"WorldClockWidget\",\r\n        \"disabled\": false,\r\n        \"content\": {"
            "\r\n          \"timeZoneId\": \"Europe\/Warsaw\",\r\n          \"dateFormat\": \"dddd, DD\/MM\/YYYY\","
            "\r\n          \"timeFormat\": \"HH:mm:ss\",\r\n          \"displayDate\": true,"
            "\r\n          \"displayTime\": true,\r\n          \"textSize\": \"subtitle2\",\r\n          \"widgetStatus\":"
            " \"FAIL\",\r\n          \"lastUpdated\": 1609354399797\r\n        },\r\n        \"status\": \"FAIL\","
            "\r\n        \"isUpdating\": false,\r\n        \"boardId\": \"board-21b6c72f-a4ac-4c62-adc4-8a2ec8c5a71d\","
            "\r\n        \"timeZoneId\": \"Europe\/Warsaw\",\r\n        \"dateFormat\": \"dddd, DD\/MM\/YYYY\","
            "\r\n        \"timeFormat\": \"HH:mm:ss\",\r\n        \"displayDate\": true,\r\n        \"displayTime\":"
            " true,\r\n        \"textSize\": \"subtitle2\"\r\n      }";
        Map<String, dynamic> updatedWidget10Data = Map<String, dynamic>.from(jsonDecode(updatedWidget10DataString));
        configProvider.updateWidget(updatedWidget10Data);

        // when
        bool shouldNotify = configProvider.shouldNotify();

        // then
        expect(shouldNotify, true);
      });
    });

    test('should set hint seen', () async {
      // given
      SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
      SharedPreferences.setMockInitialValues({});
      ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);

      // when
      await configProvider.setHintSeen(Hints.REFRESH_FETCHING_CONFIG);

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.hints[Hints.REFRESH_FETCHING_CONFIG], false);
    });

    test('should remove quarantine widgets', () async {
      // given
      SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
      SharedPreferences.setMockInitialValues({});
      ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);
      await configProvider.fetchConfig();
      configProvider.getAllWidgets().forEach((element) async {
         await configProvider.addQuarantineWidget(element);
      });
      SharedPreferences pref = await SharedPreferences.getInstance();

      // when
      await configProvider.removeQuarantineWidgets();

      // then
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.currentConnection.quarantineWidgets.isEmpty, true);
    });

    test('should remove favourite widget', () async {
      // given
      SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
      SharedPreferences.setMockInitialValues({});
      ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);
      await configProvider.fetchConfig();
      await configProvider.addFavouriteWidget(configProvider.getAllWidgets().first);
      SharedPreferences pref = await SharedPreferences.getInstance();

      // when
      await configProvider.removeFavouriteWidget(configProvider.getAllWidgets().first);

      // then
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.currentConnection.favouriteWidgets.isEmpty, true);
    });

    test('should update favourite widget', () async {
      // given
      SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
      SharedPreferences.setMockInitialValues({});
      ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);
      await configProvider.fetchConfig();
      await configProvider.addFavouriteWidget(configProvider.getAllWidgets().first);
      SharedPreferences pref = await SharedPreferences.getInstance();

      // when
      await configProvider.updateFavouriteWidget(configProvider.getAllWidgets().first);

      // then
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.currentConnection.favouriteWidgets.isEmpty, true);
    });

    test('should update quarantine widget', () async {
      // given
      SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
      SharedPreferences.setMockInitialValues({});
      ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);
      await configProvider.fetchConfig();
      await configProvider.addQuarantineWidget(configProvider.getAllWidgets().first);
      SharedPreferences pref = await SharedPreferences.getInstance();

      // when
      await configProvider.updateQuarantineWidget(configProvider.getAllWidgets().first);

      // then
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.currentConnection.quarantineWidgets.isEmpty, true);
    });

    test('should update notification timestamp', () async {
      // given
      SettingsPreferences settingsPreferences = setUpStartingSettingsPreferences();
      SharedPreferences.setMockInitialValues({});
      ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsPreferences);

      // when
      await configProvider.updateNotificationTimestamp();

      // then
      SharedPreferences pref = await SharedPreferences.getInstance();
      Map<String, dynamic> settingsPreferencesJson = jsonDecode(json.decode(pref.getString(SettingsPreferences.KEY)));
      SettingsPreferences updatedSettingsPreferences = SettingsPreferences.fromJson(settingsPreferencesJson);
      expect(updatedSettingsPreferences.lastNotificationTimestamp!=null, true);
    });
  });
}

ConfigProvider prepareConfigProviderWithSettingPreferences(SettingsPreferences settingsPreferences) {
  ConfigProvider configProvider = new ConfigProvider();
  final client = MockClient();
  when(client.get('http://150.254.30.118/api/config'))
      .thenAnswer((_) async => http.Response(getConfigJson(), 200));
  configProvider = configProvider.withSettingsPreferences(settingsPreferences);
  configProvider.client = client;
  return configProvider;
}

List<Map<String, List<String>>> widgetStatusSortValueParameters() {
  return [
    {WidgetSortTypes.NONE: ["widget9", "widget10", "widget11"]},
    {WidgetSortTypes.NAME_ASCENDING: ["widget10", "widget9", "widget11"]},
    {WidgetSortTypes.NAME_DESCENDING: ["widget11", "widget9", "widget10"]},
    {WidgetSortTypes.STATUS_ASCENDING: ["widget9", "widget11", "widget10"]},
    {WidgetSortTypes.STATUS_DESCENDING: ["widget10", "widget11", "widget9"]},
  ];
}

List<Map<WidgetStatus, bool>> isErrorWidgetStatusParameters() {
  return [
    {WidgetStatus.CHECKBOX_FAIL: true},
    {WidgetStatus.ERROR: true},
    {WidgetStatus.ERROR_CONFIGURATION: true},
    {WidgetStatus.ERROR_CONNECTION: true},
    {WidgetStatus.FAIL: true},
    {WidgetStatus.OK: false},
    {WidgetStatus.UNSTABLE: false},
    {WidgetStatus.UNKNOWN: false},
    {WidgetStatus.IN_PROGRESS: false},
    {WidgetStatus.TRANSPARENT: false},
    {WidgetStatus.CHECKBOX_OK: false},
    {WidgetStatus.CHECKBOX_UNKNOWN: false},
    {WidgetStatus.NONE: false},
  ];
}

SettingsPreferences setUpStartingSettingsPreferences() {
  SettingsPreferences settingsPreferences = new SettingsPreferences(
    connections: [],
    version: SettingsPreferences.VERSION,
    showHints: true,
    sortBy: WidgetSortTypes.NONE,
    showNotifications: false,
    hints: SettingsPreferences.createHints(),
    notificationFrequencyInMinutes: 1,
    sortByKey: WidgetSortByKeys.NONE,
    sortByOrder: WidgetSortByOrder.DESC,
  );
  settingsPreferences.currentConnection = new ConnectionPreferences(
    favouriteWidgets: [],
    quarantineWidgets: [],
    connectionName: 'test',
    connectionUrl: '150.254.30.118',
  );
  return settingsPreferences;
}

String getConfigJson() {
  return "{\r\n  \"boards\": {\r\n    \"boardsById\": {\r\n      \"board-21b6c72f-a4ac-4c62-adc4-8a2ec8c5a71d\": "
      "{\r\n        \"autoSwitch\": false,\r\n        \"switchInterval\": 360,\r\n        \"id\":"
      " \"board-21b6c72f-a4ac-4c62-adc4-8a2ec8c5a71d\",\r\n        \"theme\": \"default\",\r\n        \"widgets\": ["
      "\r\n          \"widget9\",\r\n          \"widget10\",\r\n          \"widget11\"\r\n        ],\r\n        \""
      "columns\": 8,\r\n        \"title\": \"TestBoard 1\",\r\n        \"type\": \"WidgetBoard\"\r\n      }\r\n    },"
      "\r\n    \"allBoards\": [\r\n      \"board-21b6c72f-a4ac-4c62-adc4-8a2ec8c5a71d\"\r\n    ]\r\n  },"
      "\r\n  \"widgets\": {\r\n    \"allWidgets\": [\r\n      \"widget9\",\r\n      \"widget10\",\r\n      \""
      "widget11\"\r\n    ],\r\n    \"widgetsById\": {\r\n      \"widget9\": {\r\n        \"id\": \"widget9\","
      "\r\n        \"title\": \"\",\r\n        \"config\": {\r\n          \"columns\": 4,\r\n          \"goNewLine\":"
      " false,\r\n          \"rows\": 0.5\r\n        },\r\n        \"type\": \"TextWidget\",\r\n        \"disabled\":"
      " false,\r\n        \"content\": {\r\n          \"text\": \"CogBoard\",\r\n          \"textSize\": \"h4\","
      "\r\n          \"isVertical\": false,\r\n          \"lastUpdated\": 1609354399800\r\n        },"
      "\r\n        \"status\": \"UNKNOWN\",\r\n        \"isUpdating\": false,\r\n        \"boardId\":"
      " \"board-21b6c72f-a4ac-4c62-adc4-8a2ec8c5a71d\",\r\n        \"text\": \"CogBoard\",\r\n        \"textSize\":"
      " \"h4\",\r\n        \"isVertical\": false,\r\n        \"expandContent\": false\r\n      },\r\n      \"widget10\":"
      " {\r\n        \"id\": \"widget10\",\r\n        \"title\": \"PL\",\r\n        \"config\": {"
      "\r\n          \"columns\": 2,\r\n          \"goNewLine\": false,\r\n          \"rows\": 0.5\r\n        },"
      "\r\n        \"type\": \"WorldClockWidget\",\r\n        \"disabled\": false,\r\n        \"content\": {"
      "\r\n          \"timeZoneId\": \"Europe\/Warsaw\",\r\n          \"dateFormat\": \"dddd, DD\/MM\/YYYY\","
      "\r\n          \"timeFormat\": \"HH:mm:ss\",\r\n          \"displayDate\": true,\r\n          \"displayTime\":"
      " true,\r\n          \"textSize\": \"subtitle2\",\r\n          \"widgetStatus\":"
      " \"UNKNOWN\",\r\n          \"lastUpdated\": 1609354399797\r\n        },"
      "\r\n        \"status\": \"UNKNOWN\",\r\n        \"isUpdating\": false,\r\n        \"boardId\":"
      " \"board-21b6c72f-a4ac-4c62-adc4-8a2ec8c5a71d\",\r\n        \"timeZoneId\": \"Europe\/Warsaw\","
      "\r\n        \"dateFormat\": \"dddd, DD\/MM\/YYYY\",\r\n        \"timeFormat\": \"HH:mm:ss\","
      "\r\n        \"displayDate\": true,\r\n        \"displayTime\": true,\r\n        \"textSize\":"
      " \"subtitle2\"\r\n      },\r\n      \"widget11\": {\r\n        \"id\": \"widget11\",\r\n        \"title\":"
      " \"USA - LA\",\r\n        \"config\": {\r\n          \"columns\": 2,\r\n          \"goNewLine\": false,"
      "\r\n          \"rows\": 0.5\r\n        },\r\n        \"type\": \"WorldClockWidget\",\r\n        \"disabled\":"
      " false,\r\n        \"content\": {\r\n          \"timeZoneId\": \"Etc\/GMT+8\",\r\n          \"dateFormat\":"
      " \"dddd, DD\/MM\/YYYY\",\r\n          \"timeFormat\": \"h:mm:ss a\",\r\n          \"displayDate\": false,"
      "\r\n          \"displayTime\": true,\r\n          \"textSize\": \"subtitle1\",\r\n          \"lastUpdated\":"
      " 1609354399801\r\n        },\r\n        \"status\": \"FAIL\",\r\n        \"isUpdating\": false,"
      "\r\n        \"boardId\": \"board-21b6c72f-a4ac-4c62-adc4-8a2ec8c5a71d\",\r\n        \"timeZoneId\":"
      " \"Etc\/GMT+8\",\r\n        \"dateFormat\": \"dddd, DD\/MM\/YYYY\",\r\n        \"timeFormat\": \"h:mm:ss a\","
      "\r\n        \"displayDate\": false,\r\n        \"displayTime\": true,\r\n        \"textSize\":"
      " \"subtitle1\"\r\n      }\r\n    },\r\n    \"widgetTypes\": [\r\n      {\r\n        \"value\": \"TextWidget\","
      "\r\n        \"display\": \"Text\"\r\n      },\r\n      {\r\n        \"value\": \"WorldClockWidget\","
      "\r\n        \"display\": \"World Clock\"\r\n      }\r\n    ]\r\n  }\r\n}";
}
