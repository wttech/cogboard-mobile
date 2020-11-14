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

    return RefreshIndicator(
      onRefresh: configProvider.fetchConfig,
      child: configProvider.webSocketConnectionErrorPresent
          ? ScreenWithAppBar(
              appBarTitle: AppLocalizations.of(context).getTranslation('widgetListScreen.errorTitle'),
              body: WidgetListErrorScreen(AppLocalizations.of(context).getTranslation('widgetListScreen.errorBody')),
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
                            ? WidgetListItem(
                                widget: widgetsList[index],
                                widgetIndex: index,
                                dashboardType: dashboardType,
                                lastWidget: index == widgetsList.length - 1,
                              )
                            : DismissibleWidgetListItem(
                                widget: widgetsList[index],
                                widgetIndex: index,
                                dashboardType: dashboardType,
                                lastWidget: index == widgetsList.length - 1,
                              );
                      }),
                ),
    );
  }

  List<DashboardWidget> getWidgetsList(
      ConfigProvider configProvider, DashboardType dashboardType, FilterProvider filterProvider) {
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
