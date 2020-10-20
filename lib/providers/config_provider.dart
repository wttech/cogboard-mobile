import 'dart:convert';
import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/config_model.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfigProvider with ChangeNotifier {
  Config _config;
  List<Board> _boards;
  UrlPreferences _urlPreferences;
  String _currentUrl = 'http://150.254.30.119/api/config';
  List<String> _favouriteWidgetsToBeDeleted = [];
  List<String> _quarantineWidgetsToBeDeleted = [];

  List<String> get favouriteWidgetsToBeDeleted => _favouriteWidgetsToBeDeleted;
  List<String> get quarantineWidgetsToBeDeleted => _quarantineWidgetsToBeDeleted;

  List<DashboardWidget> get favouriteWidgets {
    return _config.widgets.widgetsById.entries
        .map((entry) => entry.value)
        .where((widget) => _urlPreferences.favouriteWidgetIds.contains(widget.id))
        .toList();
  }

  List<DashboardWidget> get quarantineWidgets {
    return _config.widgets.widgetsById.entries
        .map((entry) => entry.value)
        .where((widget) => _urlPreferences.quarantineWidgetIds.contains(widget.id))
        .toList();
  }

  List<Board> get boards {
    return [..._boards];
  }

  Future<void> fetchConfig() async {
    final response = await http.get(_currentUrl);
    _config = Config.fromJson(json.decode(response.body) as Map<String, dynamic>);
    _boards = _config.boards.boardsById.entries.map((entry) => entry.value).toList();
    if (await SharedPref.containsKey(_currentUrl)) {
      _urlPreferences = UrlPreferences.fromJson(jsonDecode(await SharedPref.read(_currentUrl)));
    } else {
      _urlPreferences = new UrlPreferences(favouriteWidgetIds: [], quarantineWidgetIds: []);
    }
    notifyListeners();
  }

  List<DashboardWidget> getBoardWidgets(Board board) {
    return _config.widgets.widgetsById.entries
        .map((entry) => entry.value)
        .where((widget) => board.widgets.contains(widget.id))
        .toList();
  }

  void updateWidget(Map<String, dynamic> widgetData) {
    this._config.widgets.widgetsById.forEach((key, value) {
      if (key == widgetData['id']) {
        value.updateWidget(widgetData);
        notifyListeners();
      }
    });
  }

  Future<void> updateFavouriteWidget(DashboardWidget widget) async {
    if(favouriteWidgets.contains(widget)) {
      await removeFavouriteWidget(widget);
    } else {
      _urlPreferences.favouriteWidgetIds.add(widget.id);
      await SharedPref.save(_currentUrl, jsonEncode(_urlPreferences.toJson()));
      notifyListeners();
    }
  }

  Future<void> updateQuarantineWidget(DashboardWidget widget) async {
    if(quarantineWidgets.contains(widget)) {
      await removeQuarantineWidget(widget);
    } else {
      _urlPreferences.quarantineWidgetIds.add(widget.id);
      await SharedPref.save(_currentUrl, jsonEncode(_urlPreferences.toJson()));
      notifyListeners();
    }
  }

  Future<void> removeFavouriteWidget(DashboardWidget widget) async {
    _urlPreferences.favouriteWidgetIds.removeWhere((widgetId) => widgetId == widget.id);
    await SharedPref.save(_currentUrl, jsonEncode(_urlPreferences.toJson()));
    notifyListeners();
  }

  Future<void> removeQuarantineWidget(DashboardWidget widget) async {
    _urlPreferences.quarantineWidgetIds.removeWhere((widgetId) => widgetId == widget.id);
    await SharedPref.save(_currentUrl, jsonEncode(_urlPreferences.toJson()));
    notifyListeners();
  }

  void setFavouriteWidgetToBeDeleted(DashboardWidget dashboardWidget) {
    _favouriteWidgetsToBeDeleted.add(dashboardWidget.id);
  }

  void setQuarantineWidgetToBeDeleted(DashboardWidget dashboardWidget) {
    _quarantineWidgetsToBeDeleted.add(dashboardWidget.id);
  }

  void unsetFavouriteWidgetToBeDeleted(DashboardWidget dashboardWidget) {
    _favouriteWidgetsToBeDeleted.remove(dashboardWidget.id);
  }

  void unsetQuarantineWidgetToBeDeleted(DashboardWidget dashboardWidget) {
    _quarantineWidgetsToBeDeleted.remove(dashboardWidget.id);
  }
}
