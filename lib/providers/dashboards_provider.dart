import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:flutter/material.dart';

class DashboardsProvider with ChangeNotifier {

  final List<DashboardTab> _dashboardTabs = [
    DashboardTab(
      dashboardType: DashboardType.Home,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      dashboardType: DashboardType.Favourites,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      dashboardType: DashboardType.Quarantine,
      selectedTabColor: Colors.white,
    )
  ];

  int _dashboardTabIndex;

  DashboardsProvider() {
    _dashboardTabIndex = _dashboardTabs
        .indexWhere((element) => element.dashboardType == DashboardType.Home);
  }

  DashboardType get currentDashboardType {
    return _dashboardTabs[dashboardTabIndex].dashboardType;
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
