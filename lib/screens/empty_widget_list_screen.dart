import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';

class EmptyWidgetListScreen extends StatelessWidget {

  final Board board;
  final DashboardType dashboardType;

  EmptyWidgetListScreen({this.board, this.dashboardType});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (dashboardType != DashboardType.Home || board.type == BoardTypes.WIDGET_BOARD) ? Text(
        AppLocalizations.of(context).getTranslation('emptyWidgetList.body'),
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ): Container(),
    );
  }
}
