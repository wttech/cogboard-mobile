import 'dart:convert';

import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/boards_model.dart';
import 'package:cogboardmobileapp/models/config_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfigProvider with ChangeNotifier {
  Config _config;
  int _currentBoardIndex = 0;
  List<DashboardWidget> _boardWidgets;
  List<Board> _availableBoards;

  List<DashboardWidget> get boardWidgets {
    return [..._boardWidgets];
  }

  Future<void> fetchConfig() async {
    const url = 'http://150.254.30.119/api/config';
    final response = await http.get(url);
    _config = Config.fromJson(json.decode(response.body) as Map<String, dynamic>);
    _availableBoards = _config.boards.boardsById.entries.map((entry) => entry.value).toList();
    setBoardWidgets(_availableBoards[_currentBoardIndex]);
    notifyListeners();
  }

  void setBoardWidgets(Board board) {
    _boardWidgets = _config.widgets.widgetsById.entries.map((entry) => entry.value)
        .where((widget) => board.widgets.contains(widget.id))
        .toList();
    notifyListeners();
  }
}
