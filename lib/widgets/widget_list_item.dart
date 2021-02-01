import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/screens/widget_screen.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WidgetListItem extends StatelessWidget {
  final DashboardWidget widget;
  final int widgetIndex;
  final DashboardType dashboardType;
  final bool lastWidget;

  WidgetListItem({@required this.widget, @required this.widgetIndex, @required this.dashboardType, @required this.lastWidget});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getWidgetColor(widget),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 70,
          child: Center(
            child: ListTile(
              key: Key('widget_${widget.type}_${widget.id}'),
              title: Text(
                Provider.of<ConfigProvider>(context, listen: false).getWidgetName(widget),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                key: Key('widget_${widget.type}_${widget.id}_title'),
              ),
              subtitle: getWidgetTileSubtitle(),
              trailing: getWidgetIcon(widget),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  DashboardItemScreen.routeName,
                  arguments: widget,
                ).then((_) => Provider.of<FilterProvider>(
                      context,
                      listen: false,
                    ).resetFilterView());
              },
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsets getCardMargin() {
  return EdgeInsets.all(0);
  }

  Widget getWidgetTileSubtitle() {
    return dashboardType == DashboardType.Quarantine
        ? (widget.expirationDate != null
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.alarm,
                      size: 22,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(DateFormat('yyyy-MM-dd').format(widget.expirationDate)),
                  ],
                ),
              )
            : null)
        : null;
  }

  Color getWidgetColor(DashboardWidget dashboardWidget) {
    if (dashboardWidget.content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
      final WidgetStatus widgetStatus =
          EnumToString.fromString(WidgetStatus.values, widget.content[DashboardWidget.WIDGET_STATUS_KEY]);
      return StatusColors[EnumToString.convertToString(widgetStatus)];
    } else {
      return StatusColors["DEFAULT"];
    }
  }

  Widget getWidgetIcon(DashboardWidget dashboardWidget) {
    if (dashboardWidget.type == "AemHealthcheckWidget") {
      return Icon(
        Icons.show_chart,
        size: WIDGET_ICON_SIZE,
        color: Colors.white,
      );
    }
    if (dashboardWidget.content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
      final WidgetStatus widgetStatus =
          EnumToString.fromString(WidgetStatus.values, widget.content[DashboardWidget.WIDGET_STATUS_KEY]);
      switch (widgetStatus) {
        case WidgetStatus.OK:
          return Icon(
            Icons.check,
            size: WIDGET_ICON_SIZE,
            color: Colors.white,
          );
          break;
        case WidgetStatus.CHECKBOX_OK:
          return Icon(
            Icons.check,
            size: WIDGET_ICON_SIZE,
            color: Colors.white,
          );
          break;
        case WidgetStatus.ERROR:
          return Icon(
            Icons.error,
            size: WIDGET_ICON_SIZE,
            color: Colors.white,
          );
          break;
        case WidgetStatus.ERROR_CONFIGURATION:
          return Icon(
            Icons.warning,
            size: WIDGET_ICON_SIZE,
            color: Colors.white,
          );
          break;
        case WidgetStatus.FAIL:
          return Icon(
            Icons.block,
            size: WIDGET_ICON_SIZE,
            color: Colors.white,
          );
          break;
        case WidgetStatus.CHECKBOX_FAIL:
          return Icon(
            Icons.clear,
            size: WIDGET_ICON_SIZE,
            color: Colors.white,
          );
          break;
        case WidgetStatus.UNSTABLE:
          return null;
          break;
        case WidgetStatus.UNKNOWN:
          return Icon(
            Icons.help_outline,
            size: WIDGET_ICON_SIZE,
            color: Colors.white,
          );
          break;
        case WidgetStatus.CHECKBOX_UNKNOWN:
          return Icon(
            Icons.remove,
            size: WIDGET_ICON_SIZE,
            color: Colors.white,
          );
          break;
        case WidgetStatus.IN_PROGRESS:
          return SizedBox(
              height: WIDGET_ICON_SIZE,
              width: WIDGET_ICON_SIZE,
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
