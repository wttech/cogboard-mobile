import 'package:cogboardmobileapp/db/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'models/material_colors.dart';
import 'providers/config_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/dashboards_provider.dart';

import 'screens/widget_screen.dart';
import 'screens/dashboards_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/widget_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await ApplicationDatabase.init();
  runApp(CogboardApp());
}

class CogboardApp extends StatelessWidget {
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
        ChangeNotifierProvider.value(
          value: ConfigProvider(),
        )
      ],
      child: MaterialApp(
          title: 'Cogboard',
          theme: ThemeData(
            primarySwatch: primarySwatchColor,
            accentColor: accentColor,
            primaryColorBrightness: Brightness.dark,
            accentColorBrightness: Brightness.dark,
          ),
          initialRoute: LoginScreen.routeName,
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            DashboardsScreen.routeName: (ctx) => DashboardsScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            WidgetDetailsScreen.routeName: (ctx) => WidgetDetailsScreen(),
            DashboardItemScreen.routeName: (ctx) => DashboardItemScreen(),
          }),
    );
  }
}
