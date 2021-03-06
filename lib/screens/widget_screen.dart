import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:cogboardmobileapp/providers/widget_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/widgets/widgets/open_url_button.dart';
import 'package:cogboardmobileapp/widgets/widgets/widget_details.dart';
import 'package:cogboardmobileapp/widgets/widgets/widget_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardItemScreen extends StatefulWidget {
  static const routeName = '/widget';

  @override
  _DashboardItemScreenState createState() => _DashboardItemScreenState();
}

class _DashboardItemScreenState extends State<DashboardItemScreen> {
  PageController _controller;
  int pageNumber = 0;
  DashboardWidget currentWidget;
  List<DashboardWidget> initialWidgetsOrder;
  bool currentWidgetFetched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getWidgetTitle(DashboardWidget widget) => widget.title;

  String getWidgetType(DashboardWidget widget) => widget.type;

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
    final dashboardsProvider = Provider.of<DashboardsProvider>(context);

    Future.delayed(const Duration(milliseconds: 200), () {
      if (configProvider.showHints && configProvider.hints[Hints.SWIPE_WIDGET_DETAILS]) {
        Provider.of<ConfigProvider>(context, listen: false).setHintSeen(Hints.SWIPE_WIDGET_DETAILS);
        showHintDialog(context);
      }
    });

    if (configProvider.webSocketConnectionErrorPresent) {
      Navigator.of(context).pop();
    }

    if (!currentWidgetFetched) {
      setState(() {
        currentWidgetFetched = true;
        currentWidget = ModalRoute.of(context).settings.arguments;
        initialWidgetsOrder = configProvider.getBoardWidgets(configProvider.currentBoard);
        switch (dashboardsProvider.currentDashboardType) {
          case DashboardType.Home:
            initialWidgetsOrder = getWidgetsDeepCopy(configProvider.getBoardWidgets(configProvider.currentBoard));
            break;
          case DashboardType.Favourites:
            initialWidgetsOrder = getWidgetsDeepCopy(configProvider.favouriteWidgets);
            break;
          case DashboardType.Quarantine:
            initialWidgetsOrder = getWidgetsDeepCopy(configProvider.quarantineWidgets);
            break;
          default:
        }
      });
    }

    _controller = PageController(
      initialPage: getInitialPage(configProvider, dashboardsProvider),
    );
    pageNumber = getInitialPage(configProvider, dashboardsProvider);

    return Scaffold(
      appBar: AppBar(
        key: Key('widgetScreenBackButton'),
        actions: <Widget>[
          IconButton(
            key: Key('widgetScreenQuarantineButton'),
            icon: Icon(Icons.block),
            color: getQuarantineIconColor(currentWidget, configProvider, context),
            onPressed: () => onChangeWidgetStateClicked(currentWidget, configProvider, dashboardsProvider),
          ),
          IconButton(
            key: Key('widgetScreenFavouriteButton'),
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
        child: PageView.builder(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          itemCount: getWidgetLength(configProvider, dashboardsProvider),
          onPageChanged: (widgetIndex) {
            setState(() {
              setCurrentWidget(configProvider, dashboardsProvider, widgetIndex);
              pageNumber = widgetIndex;
            });
          },
          itemBuilder: (context, widgetIndex) {
            DashboardWidget widget = getNextWidget(configProvider, dashboardsProvider, widgetIndex);
            return Column(
              children: [
                WidgetStatusHeader(
                  widgetTitle: getTitleOrType(widget),
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
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  String getTitleOrType(DashboardWidget widget) {
    return getWidgetTitle(widget) != "" && getWidgetTitle(widget) != null
        ? getWidgetTitle(widget)
        : getWidgetType(widget);
  }

  List<DashboardWidget> getWidgetsDeepCopy(List<DashboardWidget> listToCopy) {
    return new List<DashboardWidget>.from(listToCopy.map((widget) => DashboardWidget.deepCopy(widget)).toList());
  }

  Future<void> showHintDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Text(
          AppLocalizations.of(context).getTranslation('widgetScreen.hintDialogText'),
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            key: Key('widgetScreenHintConfirmButton'),
            textColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(0.0),
            child: Text(AppLocalizations.of(context).getTranslation('widgetScreen.hintDialogConfirm')),
            onPressed: () {
              Provider.of<ConfigProvider>(context, listen: false).setHintSeen(Hints.SWIPE_WIDGET_DETAILS);
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      ),
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
            child: Text(AppLocalizations.of(context).getTranslation('widgetScreen.alertDialog.cancel')),
            onPressed: () {
              shouldWidgetExpireFromQuarantine = false;
              Navigator.of(ctx).pop(true);
            },
          ),
          FlatButton(
            key: Key('widgetScreenQuarantineDialogWithoutButton'),
            textColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(0.0),
            child: Text(AppLocalizations.of(context).getTranslation('widgetScreen.alertDialog.withoutExpirationDate')),
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
            child: Text(AppLocalizations.of(context).getTranslation('widgetScreen.alertDialog.withExpirationDate')),
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
      case DashboardType.Favourites:
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
        int currentWidgetIndex = configProvider
            .getBoardWidgets(configProvider.currentBoard)
            .indexWhere((element) => element.id == initialWidgetsOrder[widgetIndex].id);
        currentWidget = configProvider.getBoardWidgets(configProvider.currentBoard)[currentWidgetIndex];
        break;
      case DashboardType.Favourites:
        int currentWidgetIndex =
            configProvider.favouriteWidgets.indexWhere((element) => element.id == initialWidgetsOrder[widgetIndex].id);
        currentWidget = configProvider.favouriteWidgets[currentWidgetIndex];
        break;
      case DashboardType.Quarantine:
        int currentWidgetIndex =
            configProvider.quarantineWidgets.indexWhere((element) => element.id == initialWidgetsOrder[widgetIndex].id);
        currentWidget = configProvider.quarantineWidgets[currentWidgetIndex];
        break;
      default:
    }
  }

  DashboardWidget getNextWidget(ConfigProvider configProvider, DashboardsProvider dashboardsProvider, int widgetIndex) {
    switch (dashboardsProvider.currentDashboardType) {
      case DashboardType.Home:
        int currentWidgetIndex = configProvider
            .getBoardWidgets(configProvider.currentBoard)
            .indexWhere((element) => element.id == initialWidgetsOrder[widgetIndex].id);
        return currentWidgetIndex >= 0
            ? configProvider.getBoardWidgets(configProvider.currentBoard)[currentWidgetIndex]
            : configProvider.getBoardWidgets(configProvider.currentBoard)[0];
      case DashboardType.Favourites:
        int currentWidgetIndex =
            configProvider.favouriteWidgets.indexWhere((element) => element.id == initialWidgetsOrder[widgetIndex].id);
        return configProvider.favouriteWidgets[currentWidgetIndex];
      case DashboardType.Quarantine:
        int currentWidgetIndex =
            configProvider.quarantineWidgets.indexWhere((element) => element.id == initialWidgetsOrder[widgetIndex].id);
        return configProvider.quarantineWidgets[currentWidgetIndex];
      default:
        return null;
    }
  }

  int getWidgetLength(ConfigProvider configProvider, DashboardsProvider dashboardsProvider) {
    switch (dashboardsProvider.currentDashboardType) {
      case DashboardType.Home:
        return configProvider.getBoardWidgets(configProvider.currentBoard).length;
      case DashboardType.Favourites:
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
