import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:flutter/material.dart';

class DashboardsProvider with ChangeNotifier {

  final List<DashboardTab> _dashboardTabs = [
    DashboardTab(
      title: 'dashboard',
      dashboardType: DashboardType.Home,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      title: 'favourite',
      dashboardType: DashboardType.Favorites,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      title: 'quarantine',
      dashboardType: DashboardType.Quarantine,
      selectedTabColor: Colors.white,
    )
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

  bool get isAnyFilterPresent {
    return isWarningFilterPresent || isErrorFilterPresent;
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
