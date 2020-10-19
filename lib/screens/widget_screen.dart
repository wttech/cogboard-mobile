import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/widgets/open_url_button.dart';
import 'package:cogboardmobileapp/widgets/widget_details.dart';
import 'package:cogboardmobileapp/widgets/widget_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return widget.content["lastUpdated"] != null
        ? widget.content["lastUpdated"]
        : 0;
  }

  bool renderWidget(DashboardWidget widget) {
    return widget.content.length != 0 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    final DashboardWidget widget = ModalRoute.of(context).settings.arguments;
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.block),
            color: Theme.of(context).accentColor,
            onPressed: () => configProvider.addQuarantineWidget(widget),
          ),
          IconButton(
            icon: Icon(Icons.star),
            color: Theme.of(context).accentColor,
            onPressed: () => configProvider.addFavouriteWidget(widget),
          ),
        ],
      ),
      body: Column(
        children: [
          WidgetStatusHeader(
            widgetTitle: getWidgetTitle(widget),
            status: getWidgetStatus(widget),
            lastUpdated: getLastUpdated(widget),
          ),
          if (renderWidget(widget))
            WidgetDetails(
              widget: widget,
            ),
          if (renderWidget(widget))
            OpenUrlButton(
              widget: widget,
            ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
