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
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class DashboardsScreen extends StatelessWidget {
  static const routeName = '/dashboards';

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
      backgroundColor: Theme.of(context).primaryColor,
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
}
