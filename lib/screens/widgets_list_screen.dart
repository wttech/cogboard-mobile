import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:cogboardmobileapp/screens/empty_widget_list_screen.dart';
import 'package:cogboardmobileapp/screens/widget_list_error_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/widgets/dismissible_widget_list_item.dart';
import 'package:cogboardmobileapp/widgets/screen_with_appbar_widget.dart';
import 'package:cogboardmobileapp/widgets/widget_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetsListScreen extends StatelessWidget {
  final DashboardType dashboardType;
  final Board board;

  WidgetsListScreen({@required this.dashboardType, this.board});

  @override
  Widget build(BuildContext context) {
    final filterProvider = Provider.of<FilterProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final List<DashboardWidget> widgetsList = getWidgetsList(configProvider, dashboardType, filterProvider);

    Future.delayed(const Duration(milliseconds: 0), () {
      while (configProvider.snackBarsToRemove > 0) {
        Scaffold.of(context).removeCurrentSnackBar();
        configProvider.markSnackBarAsRemoved();
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (widgetsList.length > 0 &&
          configProvider.showHints &&
          configProvider.hints[Hints.SWIPE_TO_DELETE] &&
          (dashboardType == DashboardType.Favorites || dashboardType == DashboardType.Quarantine)) {
        Provider.of<ConfigProvider>(context, listen: false).setHintSeen(Hints.SWIPE_TO_DELETE);
        showHintDialog(context);
      }
    });

    return RefreshIndicator(
      onRefresh: configProvider.fetchConfig,
      child: configProvider.webSocketConnectionErrorPresent
          ? ScreenWithAppBar(
              appBarTitle: AppLocalizations.of(context).getTranslation('widgetListScreen.errorTitle'),
              body: WidgetListErrorScreen(
                message: AppLocalizations.of(context).getTranslation('widgetListScreen.errorBody'),
                refresh: configProvider.fetchConfig,
              ),
            )
          : widgetsList.length == 0
              ? EmptyWidgetListScreen()
              : MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      itemCount: widgetsList.length,
                      itemBuilder: (ctx, index) {
                        return dashboardType == DashboardType.Home
                            ? Padding(
                              padding: getCardMargin(index, index == widgetsList.length - 1),
                              child: WidgetListItem(
                                  widget: widgetsList[index],
                                  widgetIndex: index,
                                  dashboardType: dashboardType,
                                  lastWidget: index == widgetsList.length - 1,
                                ),
                            )
                            : Padding(
                              padding: getCardMargin(index, index == widgetsList.length - 1),
                              child: DismissibleWidgetListItem(
                                  widget: widgetsList[index],
                                  widgetIndex: index,
                                  dashboardType: dashboardType,
                                  lastWidget: index == widgetsList.length - 1,
                                ),
                            );
                      }),
                ),
    );
  }

  EdgeInsets getCardMargin(int widgetIndex, bool lastWidget) {
    if(widgetIndex == 0) {
      return EdgeInsets.fromLTRB(16, 0, 16, 8);
    } else if(lastWidget) {
      return EdgeInsets.fromLTRB(16, 8, 16, 86);
    } else {
      return EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      );
    }
  }

  Future<void> showHintDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Text(
          AppLocalizations.of(context).getTranslation('widgetListScreen.hintDialogText'),
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            textColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(0.0),
            child: Text(
              AppLocalizations.of(context).getTranslation('widgetListScreen.hintDialogConfirm'),
            ),
            onPressed: () {
              Provider.of<ConfigProvider>(context, listen: false).setHintSeen(Hints.SWIPE_TO_DELETE);
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      ),
    );
  }

  List<DashboardWidget> getWidgetsList(
      ConfigProvider configProvider, DashboardType dashboardType, FilterProvider filterProvider) {
    if(configProvider.currentConnection == null) {
      return [];
    }
    switch (dashboardType) {
      case DashboardType.Home:
        return filterProvider.getFilteredWidgetList(configProvider.getBoardWidgets(board));
        break;
      case DashboardType.Favorites:
        return filterProvider.getFilteredWidgetList(configProvider.favouriteWidgets);
        break;
      case DashboardType.Quarantine:
        return filterProvider.getFilteredWidgetList(configProvider.quarantineWidgets);
        break;
      default:
        return [];
    }
  }
}
