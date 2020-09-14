import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:cogboardmobileapp/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardsScreen extends StatelessWidget {
  static const routeName = '/dashboards';

  @override
  Widget build(BuildContext context) {
    final dashboardsProvider = Provider.of<DashboardsProvider>(context);
    final dashboardTabs = dashboardsProvider.dashboardTabs;
    return Scaffold(
      appBar: AppBar(
        title: Text(dashboardTabs[dashboardsProvider.dashboardTabIndex].title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          )
        ],
      ),
      body: dashboardTabs[dashboardsProvider.dashboardTabIndex].page,
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => dashboardsProvider.setDashboardTabIndex(index),
        selectedItemColor: dashboardTabs[dashboardsProvider.dashboardTabIndex]
            .selectedTabColor,
        unselectedItemColor: Theme.of(context).accentColor,
        currentIndex: dashboardsProvider.dashboardTabIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            title: Text('Favourite'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.block),
            title: Text('Quarantine'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.error),
            title: Text('Error'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.warning),
            title: Text('Warning'),
          ),
        ],
      ),
    );
  }
}
