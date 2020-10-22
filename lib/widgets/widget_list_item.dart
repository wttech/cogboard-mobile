import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/screens/widget_screen.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetListItem extends StatelessWidget {
  final DashboardWidget widget;
  final int widgetIndex;
  final DashboardType dashboardType;

  WidgetListItem(
      {@required this.widget,
      @required this.widgetIndex,
      @required this.dashboardType});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getWidgetColor(widget),
      elevation: 5,
      margin: widgetIndex == 0
          ? EdgeInsets.fromLTRB(16, 0, 16, 8)
          : EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(standardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
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
    );
  }

  Color getWidgetColor(DashboardWidget dashboardWidget) {
    if (dashboardWidget.content
        .containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
      final WidgetStatus widgetStatus = EnumToString.fromString(
          WidgetStatus.values,
          widget.content[DashboardWidget.WIDGET_STATUS_KEY]);
      return StatusColors[EnumToString.convertToString(widgetStatus)];
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
    if (dashboardWidget.content
        .containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
      final WidgetStatus widgetStatus = EnumToString.fromString(
          WidgetStatus.values,
          widget.content[DashboardWidget.WIDGET_STATUS_KEY]);
      switch (widgetStatus) {
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
