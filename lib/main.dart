import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/screens/add_connection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/config_provider.dart';
import 'models/material_colors_model.dart';
import 'providers/settings_provider.dart';
import 'providers/dashboards_provider.dart';
import 'screens/widget_screen.dart';
import 'screens/dashboards_screen.dart';
import 'screens/login_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/widget_details_screen.dart';

void main() async {
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
        ChangeNotifierProvider.value(
          value: ConfigProvider(),
        ),
        ChangeNotifierProvider.value(
          value: FilterProvider(),
        ),
      ],
      child: MaterialApp(
          title: 'Cogboard',
          theme: ThemeData(
            // primaryColor: Color.fromRGBO(12, 12, 12, 1),
            // primarySwatch: generateMaterialColor(Color.fromRGBO(12, 12, 12, 1)),
            colorScheme: ColorScheme(
                primary: Color(0xffbb86fc),
                primaryVariant: Color(0xffbb86fc),
                secondary: Color(0xff03dac6),
                secondaryVariant: Color(0xff03dac6),
                surface: Color(0xff121212),
                background: Color(0xff121212),
                error: Color(0xffcf6679),
                onPrimary: Color(0xff000000),
                onSecondary: Color(0xff000000),
                onSurface: Color(0xffffffff),
                onBackground: Color(0xffffffff),
                onError: Color(0xff000000),
                brightness: Brightness.dark),
            // accentColor: accentColor,
            // canvasColor: generateMaterialColor(Color.fromRGBO(23, 23, 23, 1)),
          ),
          initialRoute: LoginScreen.routeName,
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            DashboardsScreen.routeName: (ctx) => DashboardsScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            WidgetDetailsScreen.routeName: (ctx) => WidgetDetailsScreen(),
            DashboardItemScreen.routeName: (ctx) => DashboardItemScreen(),
            AddConnectionScreen.routeName: (ctx) => AddConnectionScreen(),
          }),
    );
  }
}
