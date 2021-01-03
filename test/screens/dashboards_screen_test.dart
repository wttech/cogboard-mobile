import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/settings_preferences_model.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/dashboards_screen.dart';
import 'package:cogboardmobileapp/screens/home_screen.dart';
import 'package:cogboardmobileapp/screens/widgets_list_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations_delegate.dart';
import 'package:cogboardmobileapp/widgets/widget_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../providers/config_provider_test.dart';

void main() {
  testWidgets('dashboard screen tests', (WidgetTester tester) async {
    // given when
    tester.runAsync(() async {
      SettingsProvider settingsProvider = new SettingsProvider();
      await settingsProvider.fetchSettingsPreferences();
      ConnectionPreferences currentConnection = new ConnectionPreferences(
        favouriteWidgets: [],
        quarantineWidgets: [],
        connectionName: 'test',
        connectionUrl: '150.254.30.118',
      );
      await settingsProvider.setCurrentConnection(currentConnection);
      ConfigProvider configProvider = prepareConfigProviderWithSettingPreferences(settingsProvider.settingsPreferences);
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: settingsProvider,
          ),
          ChangeNotifierProvider.value(
            value: DashboardsProvider(),
          ),
          ChangeNotifierProxyProvider<SettingsProvider, ConfigProvider>(
            create: (_) => configProvider,
            update: (_, settingsProvider, configProvider) =>
                configProvider.withSettingsPreferences(settingsProvider.settingsPreferences),
          ),
          ChangeNotifierProvider.value(
            value: FilterProvider(),
          ),
        ],
        child: Builder(
          builder: (_) => MaterialApp(
            title: 'Title',
            home: DashboardsScreen(),
            localizationsDelegates: [
              const AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
            ],
          ),
        ),
      ));
      await tester.pump(Duration.zero);

      // then
      expect(find.byType(HomeWidgetScreen), findsOneWidget);
      expect(find.byType(WidgetsListScreen), findsOneWidget);
      expect(find.byType(WidgetListItem), findsNWidgets(3));
    });
  });
}



ConfigProvider prepareConfigProviderWithSettingPreferences(SettingsPreferences settingsPreferences) {
  ConfigProvider configProvider = new ConfigProvider();
  final client = MockClient();
  when(client.get('http://150.254.30.118/api/config')).thenAnswer((_) async => http.Response(getConfigJson(), 200));
  configProvider = configProvider.withSettingsPreferences(settingsPreferences);
  configProvider.client = client;
  return configProvider;
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
