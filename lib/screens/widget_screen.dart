import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:cogboardmobileapp/providers/widget_provider.dart';
import 'package:cogboardmobileapp/screens/widget_list_error_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/widgets/screen_with_appbar_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/open_url_button.dart';
import 'package:cogboardmobileapp/widgets/widgets/widget_details.dart';
import 'package:cogboardmobileapp/widgets/widgets/widget_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class DashboardItemScreen extends StatefulWidget {
  static const routeName = '/widget';

  @override
  _DashboardItemScreenState createState() => _DashboardItemScreenState();
}

class _DashboardItemScreenState extends State<DashboardItemScreen> {
  PageController _controller;
  int pageNumber = 0;
  DashboardWidget currentWidget;
  bool currentWidgetFetched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getWidgetTitle(DashboardWidget widget) {
    return widget.title;
  }

  String getWidgetStatus(DashboardWidget widget) {
    return widget.content[DashboardWidget.WIDGET_STATUS_KEY] != null
        ? widget.content[DashboardWidget.WIDGET_STATUS_KEY]
        : 'DEFAULT';
  }

  int getLastUpdated(DashboardWidget widget) {
    return widget.content['lastUpdated'] != null ? widget.content['lastUpdated'] : 0;
  }

  bool renderWidget(DashboardWidget widget) {
    return widget.content.length != 0 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    final dashboardProvider = Provider.of<DashboardsProvider>(context);
    final channel = IOWebSocketChannel.connect('ws://${configProvider.currentUrl}/ws');

    if (!currentWidgetFetched) {
      setState(() {
        currentWidgetFetched = true;
        currentWidget = ModalRoute.of(context).settings.arguments;
      });
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.block),
            color: getQuarantineIconColor(currentWidget, configProvider, context),
            onPressed: () => onChangeWidgetStateClicked(currentWidget, configProvider, dashboardProvider),
          ),
          IconButton(
            icon: Icon(Icons.star),
            color: getFavouriteIconColor(currentWidget, configProvider, context),
            onPressed: () => configProvider.updateFavouriteWidget(currentWidget),
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
              debugPrint('ws error ${snapshot.error}');
              return ScreenWithAppBar(
                appBarTitle: AppLocalizations.of(context).getTranslation('widgetScreen.errorTitle'),
                body: WidgetListErrorScreen(
                  message: AppLocalizations.of(context).getTranslation('widgetScreen.errorBody'),
                  refresh: () {
                    setState(() {});
                  },
                ),
              );
            } else {
              _controller = PageController(
                initialPage: getInitialPage(configProvider, dashboardProvider),
              );
              pageNumber = getInitialPage(configProvider, dashboardProvider);
              return PageView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: getWidgetLength(configProvider, dashboardProvider),
                onPageChanged: (widgetIndex) {
                  setState(() {
                    setCurrentWidget(configProvider, dashboardProvider, widgetIndex);
                    pageNumber = widgetIndex;
                  });
                },
                itemBuilder: (context, widgetIndex) {
                  DashboardWidget widget = getNextWidget(configProvider, dashboardProvider, widgetIndex);
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
                },
              );
            }
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  Future<void> onChangeWidgetStateClicked(
      DashboardWidget currentWidget, ConfigProvider configProvider, DashboardsProvider dashboardsProvider) async {
    if (configProvider.isWidgetInQuarantine(currentWidget)) {
      if (dashboardsProvider.currentDashboardType == DashboardType.Quarantine) {
        Navigator.of(context).pop();
      }
      configProvider.removeQuarantineWidget(currentWidget);
      return;
    }
    bool shouldAddWidgetToQuarantine = false;
    bool shouldWidgetExpireFromQuarantine = true;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Text(
          AppLocalizations.of(context).getTranslation('widgetScreen.alertDialog.message'),
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            textColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(0.0),
            child: Text(AppLocalizations.of(context).getTranslation('widgetScreen.alertDialog.decline')),
            onPressed: () {
              shouldAddWidgetToQuarantine = true;
              shouldWidgetExpireFromQuarantine = false;
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            textColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(0.0),
            child: Text(AppLocalizations.of(context).getTranslation('widgetScreen.alertDialog.confirm')),
            onPressed: () {
              shouldAddWidgetToQuarantine = true;
              shouldWidgetExpireFromQuarantine = true;
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
    if (shouldWidgetExpireFromQuarantine) {
      await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime.now().add(Duration(days: 365)),
      ).then((pickedDate) {
        if (pickedDate == null) {
          shouldAddWidgetToQuarantine = false;
          return;
        }
        currentWidget.expirationDate = pickedDate;
      });
    }
    if (shouldAddWidgetToQuarantine) {
      if (dashboardsProvider.currentDashboardType == DashboardType.Home) {
        Navigator.of(context).pop();
      }
      configProvider.addQuarantineWidget(currentWidget);
    }
  }

  int getInitialPage(ConfigProvider configProvider, DashboardsProvider dashboardsProvider) {
    switch (dashboardsProvider.currentDashboardType) {
      case DashboardType.Home:
        return configProvider
            .getBoardWidgets(configProvider.currentBoard)
            .indexWhere((element) => element.id == currentWidget.id);
      case DashboardType.Favorites:
        return configProvider.favouriteWidgets.indexWhere((element) => element.id == currentWidget.id);
      case DashboardType.Quarantine:
        return configProvider.quarantineWidgets.indexWhere((element) => element.id == currentWidget.id);
      default:
        return 0;
    }
  }

  void setCurrentWidget(ConfigProvider configProvider, DashboardsProvider dashboardsProvider, int widgetIndex) {
    switch (dashboardsProvider.currentDashboardType) {
      case DashboardType.Home:
        currentWidget = configProvider.getBoardWidgets(configProvider.currentBoard)[widgetIndex];
        break;
      case DashboardType.Favorites:
        currentWidget = configProvider.favouriteWidgets[widgetIndex];
        break;
      case DashboardType.Quarantine:
        currentWidget = configProvider.quarantineWidgets[widgetIndex];
        break;
      default:
    }
  }

  DashboardWidget getNextWidget(ConfigProvider configProvider, DashboardsProvider dashboardsProvider, int widgetIndex) {
    switch (dashboardsProvider.currentDashboardType) {
      case DashboardType.Home:
        return configProvider.getBoardWidgets(configProvider.currentBoard)[widgetIndex];
      case DashboardType.Favorites:
        return configProvider.favouriteWidgets[widgetIndex];
      case DashboardType.Quarantine:
        return configProvider.quarantineWidgets[widgetIndex];
      default:
        return null;
    }
  }

  int getWidgetLength(ConfigProvider configProvider, DashboardsProvider dashboardsProvider) {
    switch (dashboardsProvider.currentDashboardType) {
      case DashboardType.Home:
        return configProvider.getBoardWidgets(configProvider.currentBoard).length;
      case DashboardType.Favorites:
        return configProvider.favouriteWidgets.length;
      case DashboardType.Quarantine:
        return configProvider.quarantineWidgets.length;
      default:
        return 0;
    }
  }

  Color getFavouriteIconColor(DashboardWidget widget, ConfigProvider configProvider, BuildContext context) {
    if (configProvider.favouriteWidgets.contains(widget)) {
      return Colors.yellow;
    } else {
      return Theme.of(context).colorScheme.onBackground;
    }
  }

  Color getQuarantineIconColor(DashboardWidget widget, ConfigProvider configProvider, BuildContext context) {
    if (configProvider.quarantineWidgets.contains(widget)) {
      return Colors.red;
    } else {
      return Theme.of(context).colorScheme.onBackground;
    }
  }
}
