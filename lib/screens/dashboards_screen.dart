import 'dart:async';
import 'dart:convert';

import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:cogboardmobileapp/screens/home_screen.dart';
import 'package:cogboardmobileapp/screens/widget_list_error_screen.dart';
import 'package:cogboardmobileapp/screens/widget_list_loading_screen.dart';
import 'package:cogboardmobileapp/screens/widgets_list_screen.dart';
import 'package:cogboardmobileapp/widgets/dashboards_screen_bottom_navigation_bar.dart';
import 'package:cogboardmobileapp/widgets/filters_widget.dart';
import 'package:cogboardmobileapp/widgets/screen_with_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../main.dart';

class DashboardsScreen extends StatefulWidget {
  static const routeName = '/dashboards';

  @override
  _DashboardsScreenState createState() => _DashboardsScreenState();
}

class _DashboardsScreenState extends State<DashboardsScreen> with WidgetsBindingObserver {
  AppLifecycleState _notification;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings _androidInitializationSettings;
  IOSInitializationSettings _iosInitializationSettings;
  InitializationSettings _initializationSettings;

  bool _appResumedBySelectingNotification = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationSetup();
    Future.delayed(const Duration(milliseconds: 0), () {
      new Timer.periodic(const Duration(minutes: 1), (timer) => checkForWidgetErrorUpdate(timer));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    if (_notification == AppLifecycleState.resumed) {
      if (_appResumedBySelectingNotification) {
        CogboardApp.navigatorKey.currentState.popUntil(ModalRoute.withName(DashboardsScreen.routeName));
        _appResumedBySelectingNotification = false;
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
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<ConfigProvider>(context, listen: false).fetchConfig(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return ScreenWithAppBar(body: WidgetListLoadingScreen());
          } else {
            if (dataSnapshot.error != null) {
              debugPrint('ws error ${dataSnapshot.error}');
              return ScreenWithAppBar(
                appBarTitle: 'Board error',
                body: WidgetListErrorScreen("api connection error occurred!"),
              );
            } else {
              startWebSocketListening(context);
              return Consumer<DashboardsProvider>(builder: (ctx, dashboardsProvider, child) {
                final dashboardTabs = dashboardsProvider.dashboardTabs;
                return dashboardTabs[dashboardsProvider.dashboardTabIndex].dashboardType == DashboardType.Home
                    ? HomeWidgetScreen()
                    : ScreenWithAppBar(
                        appBarTitle: dashboardTabs[dashboardsProvider.dashboardTabIndex].title,
                        body: WidgetsListScreen(
                            dashboardType: dashboardTabs[dashboardsProvider.dashboardTabIndex].dashboardType),
                      );
              });
            }
          }
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: DashboardsScreenBottomNavigationBar(),
      floatingActionButton: Filters(),
    );
  }

  void startWebSocketListening(BuildContext context) {
    final channel = IOWebSocketChannel.connect('ws://150.254.30.119/ws');
    channel.stream.listen(
      (dynamic message) {
        Map<String, dynamic> decodedData = Map<String, dynamic>.from(jsonDecode(message));
        if (decodedData['eventType'] == 'widget-update') {
          Future.delayed(const Duration(milliseconds: 0), () {
            Provider.of<ConfigProvider>(context, listen: false).updateWidget(decodedData);
          });
        }
      },
      onDone: () {
        debugPrint('ws channel closed');
      },
      onError: (error) {
        Future.delayed(const Duration(milliseconds: 0), () {
          Provider.of<ConfigProvider>(context, listen: false).setWebSocketConnectionErrorPresent();
        });
        debugPrint('ws error $error');
      },
    );
  }

  void notificationSetup() async {
    _androidInitializationSettings = AndroidInitializationSettings('cogboard_icon');
    _iosInitializationSettings = IOSInitializationSettings();
    _initializationSettings =
        InitializationSettings(android: _androidInitializationSettings, iOS: _iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(_initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void checkForWidgetErrorUpdate(Timer timer) async {

    if (_notification == AppLifecycleState.paused) {
      if (Provider.of<ConfigProvider>(context, listen: false).shouldNotify()) {
        await showNotification();
      }
    }
  }

  Future<void> showNotification() async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.high, importance: Importance.max, ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(0, 'Some widgets have changed their status:',
        Provider.of<ConfigProvider>(context, listen: false).notificationPayload, notificationDetails);
  }

  Future<dynamic> onSelectNotification(String payLoad) async {
    _appResumedBySelectingNotification = true;
  }
}
