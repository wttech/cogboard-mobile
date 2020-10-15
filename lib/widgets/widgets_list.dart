import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/screens/widget_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetsList extends StatelessWidget {
  final List<DashboardWidget> boardWidgets;
  final DashboardType dashboardType;

  WidgetsList({@required this.boardWidgets, @required this.dashboardType});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    return Expanded(
      child: ListView.builder(
          itemCount: boardWidgets.length,
          itemBuilder: (ctx, index) {
            return Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DashboardItemScreen.routeName,
                      arguments: boardWidgets[index],
                    );
                  },
                  title: Text(
                    boardWidgets[index].title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
