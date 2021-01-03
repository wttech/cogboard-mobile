import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/login_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('login screen tests', () {
    testWidgets('login screen test no connection saved', (WidgetTester tester) async {
      SettingsProvider settingsProvider = new SettingsProvider();
      settingsProvider.createSettingsPreferences();
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: settingsProvider,
          ),
        ],
        child: Builder(
          builder: (_) => MaterialApp(
            title: 'Title',
            home: LoginScreen(),
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
    });
  });
}
