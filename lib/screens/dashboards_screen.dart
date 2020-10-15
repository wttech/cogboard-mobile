import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:cogboardmobileapp/screens/settings_screen.dart';
import 'package:cogboardmobileapp/widgets/filters_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardsScreen extends StatelessWidget {
  static const routeName = '/dashboards';

  @override
  Widget build(BuildContext context) {
    final dashboardsProvider = Provider.of<DashboardsProvider>(context);
    final dashboardTabs = dashboardsProvider.dashboardTabs;
    final BottomNavigationBar bottomNavigationBar = getBottomNavigationBar(context, dashboardsProvider);

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
      body: Container(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: Provider.of<ConfigProvider>(context, listen: false).fetchConfig(),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (dataSnapshot.error != null) {
                    print(dataSnapshot.error);
                    // TODO handling errors
                    return Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Consumer<ConfigProvider>(
                      builder: (ctx, configProvider, child) => WidgetsList(
                        boardWidgets: configProvider.boardWidgets,
                        dashboardType: dashboardTabs[dashboardsProvider.dashboardTabIndex].dashboardType,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: Filters(),
    );
  }

  BottomNavigationBar getBottomNavigationBar(BuildContext context, DashboardsProvider dashboardsProvider) {
    final dashboardTabs = dashboardsProvider.dashboardTabs;

    return BottomNavigationBar(
      selectedItemColor: dashboardTabs[dashboardsProvider.dashboardTabIndex].selectedTabColor,
      unselectedItemColor: Theme.of(context).accentColor,
      currentIndex: dashboardsProvider.dashboardTabIndex,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
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
      ],
      onTap: (tabIndex) =>dashboardsProvider.setDashboardTabIndex(tabIndex),
    );
  }
}
