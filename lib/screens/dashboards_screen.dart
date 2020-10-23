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
import 'package:websocket_manager/websocket_manager.dart';

class DashboardsScreen extends StatefulWidget {
  static const routeName = '/dashboards';

  @override
  _DashboardsScreenState createState() => _DashboardsScreenState();
}

class _DashboardsScreenState extends State<DashboardsScreen> with WidgetsBindingObserver {
  AppLifecycleState _notification;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializing();

    final socket = WebsocketManager('ws://150.254.30.119/ws');
    socket.onMessage((dynamic message) {
//      print('recv: $message');
    });
    socket.connect();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardsProvider = Provider.of<DashboardsProvider>(context);
    final dashboardTabs = dashboardsProvider.dashboardTabs;
    final channel = IOWebSocketChannel.connect('ws://150.254.30.119/ws');

//    Future.delayed(const Duration(milliseconds: 0), () {
//      _showNotifications();
//    });

    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<ConfigProvider>(context, listen: false).fetchConfig(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return ScreenWithAppBar(
              appBarTitle: dashboardTabs[dashboardsProvider.dashboardTabIndex].title,
              body: WidgetListLoadingScreen(),
            );
          } else {
            if (dataSnapshot.error != null) {
              // TODO handling errors
              return ScreenWithAppBar(
                appBarTitle: dashboardTabs[dashboardsProvider.dashboardTabIndex].title,
                body: WidgetListErrorScreen(),
              );
            } else {
              return StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    // TODO handling errors
                    return ScreenWithAppBar(
                      appBarTitle: dashboardTabs[dashboardsProvider.dashboardTabIndex].title,
                      body: WidgetListErrorScreen(),
                    );
                  }
                  if (snapshot.hasData) {
                    print('tutaj');
                    if (_notification == AppLifecycleState.paused) {
                      print('tutaj2');
                    }
                    Map<String, dynamic> decodedData = Map<String, dynamic>.from(jsonDecode(snapshot.data));
                    if (decodedData['eventType'] == 'widget-update') {
                      Future.delayed(const Duration(milliseconds: 0), () {
                        Provider.of<ConfigProvider>(context, listen: false).updateWidget(decodedData);
                      });
                    }
                  }
                  return dashboardTabs[dashboardsProvider.dashboardTabIndex].dashboardType == DashboardType.Home
                      ? HomeWidgetScreen()
                      : ScreenWithAppBar(
                          appBarTitle: dashboardTabs[dashboardsProvider.dashboardTabIndex].title,
                          body: WidgetsListScreen(
                              dashboardType: dashboardTabs[dashboardsProvider.dashboardTabIndex].dashboardType),
                        );
                },
              );
            }
          }
        },
      ),
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: DashboardsScreenBottomNavigationBar(),
      floatingActionButton: Filters(),
    );
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('cogboard_icon');
    iosInitializationSettings = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings =
        InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    await notification();
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.high, importance: Importance.max, ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Some widgets have changed their status', 'test', notificationDetails);
  }

  Future<dynamic> onSelectNotification(String payLoad) {
//    print('tutaj');
//    while (Navigator.canPop(context)) Navigator.removeRouteBelow(context, ModalRoute.of(context));
//    Navigator.pushNamed(
//      context,
//      DashboardsScreen.routeName,
//    );
    return null;
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }
}
