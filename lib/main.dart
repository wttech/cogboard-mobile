import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/screens/add_connection_screen.dart';
import 'package:cogboardmobileapp/screens/login_projects_screen.dart';
import 'package:cogboardmobileapp/screens/settings_general_screen.dart';
import 'package:cogboardmobileapp/screens/settings_projects_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/config_provider.dart';
import 'providers/dashboards_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/dashboards_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/widget_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(CogboardApp());
}

class CogboardApp extends StatelessWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: SettingsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: DashboardsProvider(),
        ),
        ChangeNotifierProxyProvider<SettingsProvider, ConfigProvider>(
          create: (_) => ConfigProvider(),
          update: (_, settingsProvider, configProvider) =>
              configProvider.withSettingsPreferences(settingsProvider.settingsPreferences),
        ),
        ChangeNotifierProvider.value(
          value: FilterProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Cogboard',
        theme: ThemeData(
          colorScheme: ColorScheme(
              primary: Color(0xff81D4FA),
              primaryVariant: Color(0xff81D4FA),
              secondary: Color(0xffaed581),
              secondaryVariant: Color(0xffaed581),
              surface: Color(0xff202020),
              background: Color(0xff121212),
              error: Color(0xffcf6679),
              onPrimary: Color(0xff000000),
              onSecondary: Color(0xff000000),
              onSurface: Color(0xffffffff),
              onBackground: Color(0xffffffff),
              onError: Color(0xff000000),
              brightness: Brightness.dark),
        ),
        navigatorKey: CogboardApp.navigatorKey,
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (ctx) => LoginScreen(),
          LoginProjectsScreen.routeName: (ctx) => LoginProjectsScreen(),
          DashboardsScreen.routeName: (ctx) => DashboardsScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          DashboardItemScreen.routeName: (ctx) => DashboardItemScreen(),
          AddConnectionScreen.routeName: (ctx) => AddConnectionScreen(
                editMode: false,
              ),
          SettingsProjectsScreen.routeName: (ctx) => SettingsProjectsScreen(),
          SettingsGeneralScreen.routeName: (ctx) => SettingsGeneralScreen(),
        },
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
    );
  }
}
