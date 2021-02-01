import 'package:cogboardmobileapp/screens/settings_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('settings screen test', (WidgetTester tester) async {
    // given when
    await tester.pumpWidget(MaterialApp(
      title: 'Title',
      home: SettingsScreen(),
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
    ));

    // then
    expect(find.byType(ListTile), findsNWidgets(2));
    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);
  });
}