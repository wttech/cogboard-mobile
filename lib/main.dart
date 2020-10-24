import 'dart:async';

import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/screens/add_connection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

class CogboardApp extends StatefulWidget {
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  _CogboardAppState createState() => _CogboardAppState();
}

class _CogboardAppState extends State<CogboardApp> with WidgetsBindingObserver {

  AppLifecycleState _notification;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  bool appResumedBySelectingNotification = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationSetup();
    Future.delayed(const Duration(milliseconds: 0), () {
      new Timer.periodic(const Duration(seconds: 2), (timer) => checkForWidgetErrorUpdate(timer));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    if(_notification==AppLifecycleState.resumed) {
      if(appResumedBySelectingNotification) {
        CogboardApp.navigatorKey.currentState.popUntil(ModalRoute.withName(DashboardsScreen.routeName));
        appResumedBySelectingNotification = false;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
            primarySwatch: primarySwatchColor,
            accentColor: accentColor,
            canvasColor: primarySwatchColor,
          ),
          navigatorKey:CogboardApp.navigatorKey,
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

  void notificationSetup() async {
    androidInitializationSettings = AndroidInitializationSettings('cogboard_icon');
    iosInitializationSettings = IOSInitializationSettings();
    initializationSettings =
        InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void checkForWidgetErrorUpdate(Timer timer) async {
    if (_notification == AppLifecycleState.paused) {
      await showNotification();
    }
  }

  Future<void> showNotification() async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.high, importance: Importance.max, ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Some widgets have changed their status', 'test', notificationDetails);
  }

  Future<dynamic> onSelectNotification(String payLoad) async {
    appResumedBySelectingNotification = true;
  }
}
