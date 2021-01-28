import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:cogboardmobileapp/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenWithAppBar extends StatelessWidget {
  final String appBarTitle;
  final Widget body;

  ScreenWithAppBar({this.appBarTitle, @required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 28, 4, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 9),
                  child:  appBarTitle != null ?
                  Text(
                    appBarTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ) :  Consumer<DashboardsProvider>(
                    builder: (ctx, dashboardsProvider, child) =>  Text(
                      dashboardsProvider.dashboardTabs[dashboardsProvider.dashboardTabIndex].getTitle(context),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  color: Colors.grey,
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  },
                )
              ],
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }
}
