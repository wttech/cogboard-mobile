import 'dart:convert';

import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/config_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfigProvider with ChangeNotifier {
  Config _config;
  List<DashboardWidget> _favouriteWidgets = [];
  List<DashboardWidget> _quarantineWidgets = [];
  List<Board> _boards;

  List<DashboardWidget> get favouriteWidgets {
    return [..._favouriteWidgets];
  }

  List<DashboardWidget> get quarantineWidgets {
    return [..._quarantineWidgets];
  }

  List<Board> get boards {
    return [..._boards];
  }

  Future<void> fetchConfig() async {
    const url = 'http://150.254.30.119/api/config';
    final response = await http.get(url);
    _config = Config.fromJson(json.decode(response.body) as Map<String, dynamic>);
    _boards = _config.boards.boardsById.entries.map((entry) => entry.value).toList();
    notifyListeners();
  }

  List<DashboardWidget> getBoardWidgets(Board board) {
    return _config.widgets.widgetsById.entries.map((entry) => entry.value)
        .where((widget) => board.widgets.contains(widget.id))
        .toList();
  }

  void updateWidget(Map<String, dynamic> widgetData) {
    this._config.widgets.widgetsById.forEach((key, value) {
      if(key == widgetData['id']) {
        value.updateWidget(widgetData);
        notifyListeners();
      }
    });
  }
}
