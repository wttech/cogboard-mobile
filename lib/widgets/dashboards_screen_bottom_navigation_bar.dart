import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardsScreenBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dashboardsProvider = Provider.of<DashboardsProvider>(context);

    return BottomNavigationBar(
      selectedItemColor: dashboardsProvider
          .dashboardTabs[dashboardsProvider.dashboardTabIndex].selectedTabColor,
      unselectedItemColor: Colors.grey,
      currentIndex: dashboardsProvider.dashboardTabIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).colorScheme.background,
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).colorScheme.background,
          icon: Icon(Icons.star),
          title: Text('Favourite'),
        ),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).colorScheme.background,
          icon: Icon(Icons.block),
          title: Text('Quarantine'),
        ),
      ],
      onTap: (tabIndex) {
        Scaffold.of(context).removeCurrentSnackBar();
        dashboardsProvider.setDashboardTabIndex(tabIndex);
      },
    );
  }
}
