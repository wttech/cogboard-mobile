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
import 'package:provider/provider.dart';

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
        connectionUrl: 'http://150.254.30.118',
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
