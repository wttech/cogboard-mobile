import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:flutter/material.dart';

class DashboardsProvider with ChangeNotifier {

  final List<DashboardTab> _dashboardTabs = [
    DashboardTab(
      title: 'Dashboard',
      dashboardType: DashboardType.Home,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      title: 'Favourites',
      dashboardType: DashboardType.Favorites,
      selectedTabColor: Colors.white,
    ),
    DashboardTab(
      title: 'Quarantine',
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

  DashboardType get currentDashboardType {
    return _dashboardTabs[dashboardTabIndex].dashboardType;
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
