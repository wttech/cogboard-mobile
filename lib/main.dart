import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'models/material_colors.dart';
import 'providers/settings_provider.dart';
import 'providers/dashboards_provider.dart';

import 'screens/dashboards_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/widget_details.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
      ],
      child: MaterialApp(
          title: 'Cogboard',
          theme: ThemeData(
            primarySwatch: primarySwatchColor,
            accentColor: accentColor,
          ),
          initialRoute: LoginScreen.routeName,
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            DashboardsScreen.routeName: (ctx) => DashboardsScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            WidgetDetailsScreen.routeName: (ctx) => WidgetDetailsScreen(),
          }),
    );
  }
}
