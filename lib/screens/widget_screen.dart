import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/widget_provider.dart';
import 'package:cogboardmobileapp/screens/widget_list_error_screen.dart';
import 'package:cogboardmobileapp/widgets/open_url_button.dart';
import 'package:cogboardmobileapp/widgets/screen_with_appbar_widget.dart';
import 'package:cogboardmobileapp/widgets/widget_details.dart';
import 'package:cogboardmobileapp/widgets/widget_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:web_socket_channel/io.dart';

class DashboardItemScreen extends StatelessWidget {
  static const routeName = '/widget';

  String getWidgetTitle(DashboardWidget widget) {
    return widget.title;
  }

  String getWidgetStatus(DashboardWidget widget) {
    return widget.content[DashboardWidget.WIDGET_STATUS_KEY] != null
        ? widget.content[DashboardWidget.WIDGET_STATUS_KEY]
        : '';
  }

  int getLastUpdated(DashboardWidget widget) {
    return widget.content['lastUpdated'] != null
        ? widget.content['lastUpdated']
        : 0;
  }

  bool renderWidget(DashboardWidget widget) {
    return widget.content.length != 0 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    final DashboardWidget widget = ModalRoute.of(context).settings.arguments;
    final configProvider = Provider.of<ConfigProvider>(context);
    final channel = IOWebSocketChannel.connect('ws://150.254.30.119/ws');

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.block),
            color:  getQuarantineIconColor(widget, configProvider, context),
            onPressed: () => configProvider.updateQuarantineWidget(widget),
          ),
          IconButton(
            icon: Icon(Icons.star),
            color: getFavouriteIconColor(widget, configProvider, context),
            onPressed: () => configProvider.updateFavouriteWidget(widget),
          ),
        ],
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: WidgetProvider(),
          ),
        ],
        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.error != null) {
              return ScreenWithAppBar(
                appBarTitle: 'Widget details',
                body: WidgetListErrorScreen(),
              );
            } else {
              return Column(
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
              );
            }
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Color getFavouriteIconColor(DashboardWidget widget, ConfigProvider configProvider, BuildContext context) {
    if(configProvider.favouriteWidgets.contains(widget)) {
      return Colors.yellow;
    } else {
      return Theme.of(context).accentColor;
    }
  }

  Color getQuarantineIconColor(DashboardWidget widget, ConfigProvider configProvider, BuildContext context) {
    if(configProvider.quarantineWidgets.contains(widget)) {
      return Colors.red;
    } else {
      return Theme.of(context).accentColor;
    }
  }
}
