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
    final configProvider = Provider.of<ConfigProvider>(context);

    return widgetIsGoingToBeDeleted(configProvider)
        ? SizedBox()
        : Dismissible(
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
            onDismissed: (_) => removeWidgetListItem(context, configProvider),
            child: WidgetListItem(
              widget: widget,
              widgetIndex: widgetIndex,
              dashboardType: dashboardType,
            ),
          );
  }

  bool widgetIsGoingToBeDeleted(ConfigProvider configProvider) {
    return (dashboardType == DashboardType.Favorites &&
            configProvider.favouriteWidgetsToBeDeleted.contains(widget.id)) ||
        (dashboardType == DashboardType.Quarantine && configProvider.quarantineWidgetsToBeDeleted.contains(widget.id));
  }

  Future<void> removeWidgetListItem(BuildContext context, ConfigProvider configProvider) async {
    if (dashboardType == DashboardType.Favorites) {
      configProvider.setFavouriteWidgetToBeDeleted(widget);
    } else if (dashboardType == DashboardType.Quarantine) {
      configProvider.setQuarantineWidgetToBeDeleted(widget);
    }
    await showUndoSnackBar(context, configProvider);
  }

  Future<void> showUndoSnackBar(BuildContext context, ConfigProvider configProvider) async {
    await Scaffold.of(context)
        .showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Removed ' + widget.title),
              RaisedButton(
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  if (dashboardType == DashboardType.Favorites) {
                    configProvider.unsetFavouriteWidgetToBeDeleted(widget);
                  } else if (dashboardType == DashboardType.Quarantine) {
                    configProvider.unsetQuarantineWidgetToBeDeleted(widget);
                  }
                  Scaffold.of(context).removeCurrentSnackBar();
                },
                child: const Text('undo'),
              )
            ],
          ),
        ))
        .closed;
    if (widgetIsGoingToBeDeleted(configProvider)) {
      if (dashboardType == DashboardType.Favorites) {
        configProvider.removeFavouriteWidget(widget);
      } else if (dashboardType == DashboardType.Quarantine) {
        configProvider.removeQuarantineWidget(widget);
      }
    }
  }
}
