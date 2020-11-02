import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
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

    return Dismissible(
      key: ValueKey(widget.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.background,
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

  void removeWidgetListItem(BuildContext context, ConfigProvider configProvider) {
    if (dashboardType == DashboardType.Favorites) {
      configProvider.removeFavouriteWidget(widget);
    } else if (dashboardType == DashboardType.Quarantine) {
      configProvider.removeQuarantineWidget(widget);
    }
    showUndoSnackBar(context, configProvider);
  }

  void showUndoSnackBar(BuildContext context, ConfigProvider configProvider) {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 5000),
      backgroundColor: Theme.of(context).colorScheme.background,
      content: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AppLocalizations.of(context).getTranslation('dissmisibleWidgetList.removed') + widget.title,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              FlatButton(
                textColor: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.all(0.0),
                onPressed: () {
                  if (dashboardType == DashboardType.Favorites) {
                    configProvider.addFavouriteWidget(widget);
                  } else if (dashboardType == DashboardType.Quarantine) {
                    configProvider.addQuarantineWidget(widget);
                  }
                  configProvider.addSnackBarToRemove();
                },
                child: Text(AppLocalizations.of(context).getTranslation('dissmisibleWidgetList.undo')),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
