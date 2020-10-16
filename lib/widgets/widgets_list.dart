import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/screens/widget_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetsList extends StatelessWidget {
  final DashboardType dashboardType;

  WidgetsList({@required this.dashboardType});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final List<DashboardWidget> widgetsList = getWidgetsList(configProvider, dashboardType);

    return Expanded(
      child: ListView.builder(
          itemCount: widgetsList.length,
          itemBuilder: (ctx, index) {
            return Card(
              color: getWidgetColor(widgetsList[index]),
              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    widgetsList[index].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: getWidgetIcon(widgetsList[index]),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DashboardItemScreen.routeName,
                      arguments: widgetsList[index],
                    );
                  },
                ),
              ),
            );
          }),
    );
  }

  List<DashboardWidget> getWidgetsList(ConfigProvider configProvider, DashboardType dashboardType) {
    switch(dashboardType) {
      case DashboardType.Home:
        return configProvider.boardWidgets;
        break;
      case DashboardType.Favorites:
        return configProvider.favouriteWidgets;
        break;
      case DashboardType.Quarantine:
        return configProvider.quarantineWidgets;
        break;
      default:
        return configProvider.boardWidgets;
    }
  }

  Color getWidgetColor(DashboardWidget dashboardWidget) {
    if (dashboardWidget.content.containsKey("widgetStatus")) {
      switch (dashboardWidget.content["widgetStatus"]) {
        case WidgetStatus.OK:
          return Color.fromRGBO(1, 148, 48, 1);
          break;
        case WidgetStatus.ERROR:
          return Color.fromRGBO(225, 49, 47, 1);
          break;
        case WidgetStatus.ERROR_CONFIGURATION:
          return Color.fromRGBO(225, 49, 47, 1);
          break;
        case WidgetStatus.FAIL:
          return Color.fromRGBO(225, 49, 47, 1);
          break;
        case WidgetStatus.UNSTABLE:
          return Color.fromRGBO(225, 49, 47, 1);
          break;
        case WidgetStatus.UNKNOWN:
          return Color.fromRGBO(38, 36, 62, 1);
          break;
        case WidgetStatus.IN_PROGRESS:
          return Color.fromRGBO(25, 140, 189, 1);
          break;
        default:
          return Color.fromRGBO(38, 36, 62, 1);
          break;
      }
    } else {
      return Color.fromRGBO(38, 36, 62, 1);
    }
  }

  Widget getWidgetIcon(DashboardWidget dashboardWidget) {
    if (dashboardWidget.type == "CheckboxWidget") {
      return Icon(
        Icons.indeterminate_check_box,
        color: Colors.white,
      );
    } else if (dashboardWidget.type == "AemHealthcheckWidget") {
      return Icon(
        Icons.show_chart,
        color: Colors.white,
      );
    }
    if (dashboardWidget.content.containsKey("widgetStatus")) {
      switch (dashboardWidget.content["widgetStatus"]) {
        case WidgetStatus.OK:
          return Icon(
            Icons.check,
            color: Colors.white,
          );
          break;
        case WidgetStatus.ERROR:
          return Icon(
            Icons.error,
            color: Colors.white,
          );
          break;
        case WidgetStatus.ERROR_CONFIGURATION:
          return Icon(
            Icons.warning,
            color: Colors.white,
          );
          break;
        case WidgetStatus.FAIL:
          return Icon(
            Icons.block,
            color: Colors.white,
          );
          break;
        case WidgetStatus.UNSTABLE:
          return null;
          break;
        case WidgetStatus.UNKNOWN:
          return Icon(
            Icons.help_outline,
            color: Colors.white,
          );
          break;
        case WidgetStatus.IN_PROGRESS:
          return SizedBox(
            height: 25,
              width: 25,
              child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ));
          break;
        default:
          return null;
          break;
      }
    } else {
      return null;
    }
  }
}
