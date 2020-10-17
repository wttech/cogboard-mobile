import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/open_url_button.dart';
import 'package:cogboardmobileapp/widgets/widget_status.dart';
import 'package:flutter/material.dart';

class DashboardItemScreen extends StatelessWidget {
  static const routeName = '/widget';

  String getWidgetTitle(DashboardWidget widget) {
    return widget.title;
  }

  String getWidgetStatus(DashboardWidget widget) {
    return widget.content["widgetStatus"] != null
        ? widget.content["widgetStatus"]
        : "";
  }

  int getLastUpdated(DashboardWidget widget) {
    return widget.content["lastUpdated"];
  }

  @override
  Widget build(BuildContext context) {
    final DashboardWidget widget = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          WidgetStatusHeader(
            widgetTitle: getWidgetTitle(widget),
            status: getWidgetStatus(widget),
            lastUpdated: getLastUpdated(widget),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: Text(
                        "Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      margin: const EdgeInsets.fromLTRB(30.0, 20.0, 0, 21.0),
                    )
                  ],
                ),
              ],
            ),
          ),
          OpenUrlButton(
            widget,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
