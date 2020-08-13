import 'package:cogboardmobileapp/models/dashboard_tab.dart';
import 'package:cogboardmobileapp/screens/error_widgets_screen.dart';
import 'package:cogboardmobileapp/screens/favourite_widgets_screen.dart';
import 'package:cogboardmobileapp/screens/home_screen.dart';
import 'package:cogboardmobileapp/screens/quarantine_widgets_screen.dart';
import 'package:cogboardmobileapp/screens/warning_widgets_screen.dart';
import 'package:flutter/material.dart';

class DashboardsProvider with ChangeNotifier {
  final List<DashboardTab> _dashboardTabs = [
    DashboardTab(
      page: FavoriteWidgetsScreen(),
      title: 'favourite',
      dashboardTabId: DashboardTabId.Favorites,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      page: QuarantineWidgetsScreen(),
      title: 'quarantine',
      dashboardTabId: DashboardTabId.Quarantine,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      page: HomeWidgetsScreen(),
      title: 'dashboard',
      dashboardTabId: DashboardTabId.Home,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      page: ErrorWidgetsScreen(),
      title: 'error',
      dashboardTabId: DashboardTabId.Error,
      selectedTabColor: Colors.red,
    ),
    DashboardTab(
      page: WarningWidgetsScreen(),
      title: 'warning',
      dashboardTabId: DashboardTabId.Warning,
      selectedTabColor: Colors.yellow,
    ),
  ];

  int _dashboardTabIndex;

  DashboardsProvider() {
    _dashboardTabIndex = _dashboardTabs
        .indexWhere((element) => element.dashboardTabId == DashboardTabId.Home);
  }

  int get dashboardTabIndex {
    return _dashboardTabIndex;
  }

  void setDashboardTabIndex(int dashboardTabIndex) {
    _dashboardTabIndex = dashboardTabIndex;
    notifyListeners();
  }

  List<DashboardTab> get dashboardTabs {
    return _dashboardTabs;
  }
}
