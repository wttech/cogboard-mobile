import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:flutter/material.dart';

class DashboardsProvider with ChangeNotifier {

  final List<DashboardTab> _dashboardTabs = [
    DashboardTab(
      title: 'favourite',
      dashboardType: DashboardType.Favorites,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      title: 'quarantine',
      dashboardType: DashboardType.Quarantine,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      title: 'dashboard',
      dashboardType: DashboardType.Home,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      title: 'error',
      dashboardType: DashboardType.Error,
      selectedTabColor: Colors.red,
    ),
    DashboardTab(
      title: 'warning',
      dashboardType: DashboardType.Warning,
      selectedTabColor: Colors.yellow,
    ),
  ];

  int _dashboardTabIndex;
  bool _warningFilterPresent = false;
  bool _errorFilterPresent = false;

  DashboardsProvider() {
    _dashboardTabIndex = _dashboardTabs
        .indexWhere((element) => element.dashboardType == DashboardType.Home);
  }

  int get dashboardTabIndex {
    return _dashboardTabIndex;
  }

  bool get isWarningFilterPresent {
    return _warningFilterPresent;
  }

  bool get isErrorFilterPresent {
    return _errorFilterPresent;
  }

  void setDashboardTabIndex(int dashboardTabIndex) {
    _dashboardTabIndex = dashboardTabIndex;
    notifyListeners();
  }

  List<DashboardTab> get dashboardTabs {
    return _dashboardTabs;
  }

  void toggleWarningFilter() {
    _warningFilterPresent = !_warningFilterPresent;
    notifyListeners();
  }

  void toggleErrorFilter() {
    _errorFilterPresent = !_errorFilterPresent;
    notifyListeners();
  }
}
