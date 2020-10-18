import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/screens/widget_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings_screen.dart';

class WidgetsListScreen extends StatelessWidget {
  final DashboardType dashboardType;
  final Board board;

  WidgetsListScreen({@required this.dashboardType, this.board});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final List<DashboardWidget> widgetsList =
        getWidgetsList(configProvider, dashboardType);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
            itemCount: widgetsList.length,
            itemBuilder: (ctx, index) {
              return Card(
                color: getWidgetColor(widgetsList[index]),
                elevation: 5,
                margin: index == 0 ? EdgeInsets.fromLTRB(16, 0, 16, 8) : EdgeInsets.symmetric(
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

  List<DashboardWidget> getWidgetsList(
      ConfigProvider configProvider, DashboardType dashboardType) {
    switch (dashboardType) {
      case DashboardType.Home:
        return configProvider.getBoardWidgets(board);
        break;
      case DashboardType.Favorites:
        return configProvider.favouriteWidgets;
        break;
      case DashboardType.Quarantine:
        return configProvider.quarantineWidgets;
        break;
      default:
        return [];
    }
  }

  Color getWidgetColor(DashboardWidget dashboardWidget) {
    if (dashboardWidget.content.containsKey("widgetStatus")) {
      switch (dashboardWidget.content["widgetStatus"]) {
        case WidgetStatus.OK:
          return StatusColors[WidgetStatus.OK];
          break;
        case WidgetStatus.ERROR:
          return StatusColors[WidgetStatus.ERROR];
          break;
        case WidgetStatus.ERROR_CONFIGURATION:
          return StatusColors[WidgetStatus.ERROR_CONFIGURATION];
          break;
        case WidgetStatus.FAIL:
          return StatusColors[WidgetStatus.FAIL];
          break;
        case WidgetStatus.UNSTABLE:
          return StatusColors[WidgetStatus.UNSTABLE];
          break;
        case WidgetStatus.UNKNOWN:
          return StatusColors[WidgetStatus.UNKNOWN];
          break;
        case WidgetStatus.IN_PROGRESS:
          return StatusColors[WidgetStatus.IN_PROGRESS];
          break;
        default:
          return StatusColors["DEFAULT"];
          break;
      }
    } else {
      return StatusColors["DEFAULT"];
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
