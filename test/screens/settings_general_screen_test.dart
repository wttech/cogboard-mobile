import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/settings_general_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('settings general screen tests', (WidgetTester tester) async {
    // given when
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
          home: SettingsGeneralScreen(),
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

    // then
    expect(find.byType(Divider), findsNWidgets(3));
    expect(find.text('Widgets Sorting'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Notification Frequency'), findsOneWidget);
    expect(find.text('Hints'), findsOneWidget);
  });
}