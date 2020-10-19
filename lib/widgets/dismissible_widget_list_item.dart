import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/widgets/widget_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DismissibleWidgetListItem extends StatelessWidget {
  final DashboardWidget widget;
  final int widgetIndex;
  final DashboardType dashboardType;

  DismissibleWidgetListItem({@required this.widget, @required this.widgetIndex, @required this.dashboardType});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 35,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      onDismissed: (_) {
        if (dashboardType == DashboardType.Favorites) {
          Provider.of<ConfigProvider>(context, listen: false).removeFavouriteWidget(widget);
        } else if (dashboardType == DashboardType.Quarantine) {
          Provider.of<ConfigProvider>(context, listen: false).removeQuarantineWidget(widget);
        }
      },
      child: WidgetListItem(
        widget: widget,
        widgetIndex: widgetIndex,
        dashboardType: dashboardType,
      ),
    );
  }
}
