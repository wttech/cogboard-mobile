import 'dart:async';
import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/config_model.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/models/urls_preferences_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfigProvider with ChangeNotifier {
  Config _config;
  List<Board> _boards;
  UrlsPreferences _urlsPreferences;
  UrlPreferences _currentUrlPreferences;
  String _currentUrl = '150.254.30.119';
  int _snackBarsToRemove = 0;
  bool _webSocketConnectionErrorPresent = false;
  List<DashboardWidget> _lastNotificationUpdateWidgetsState;
  String _lastNotificationUpdateUrl;
  String _notificationPayload;
  List<DashboardWidget> _widgetsInNotificationPayload = [];
  Board _currentBoard;

  ConfigProvider() {
    fetchUrlsPreferences();
    new Timer.periodic(const Duration(minutes: 1), everyMinuteCheckTimer);
  }

  Future<void> fetchUrlsPreferences() async {
    if (await SharedPref.containsKey(UrlsPreferences.KEY)) {
      _urlsPreferences = UrlsPreferences.fromJson(jsonDecode(await SharedPref.read(UrlsPreferences.KEY)));
      if(_urlsPreferences.version == null || (_urlsPreferences.version != null && _urlsPreferences.version < SharedPreferencesVersions.URL_PREFERENCES)) {
        await createUrlsPreferences();
      }
    } else {
      await createUrlsPreferences();
    }
  }

  Future createUrlsPreferences() async {
    _urlsPreferences = new UrlsPreferences(
        urls: new Map<String, UrlPreferences>(), version: SharedPreferencesVersions.URL_PREFERENCES);
    await SharedPref.save(UrlsPreferences.KEY, jsonEncode(_urlsPreferences.toJson()));
  }

  void everyMinuteCheckTimer(Timer timer) async {
    if (_currentUrlPreferences != null) {
      await checkIfQuarantineExpirationDateHasExceeded();
    }
  }

  Future<void> checkIfQuarantineExpirationDateHasExceeded() async {
    DateTime currentTime = new DateTime.now();
    bool someWidgetsWereRemoved = false;
    _currentUrlPreferences.quarantineWidgets.removeWhere((widget) {
      bool shouldRemoveWidget = widget.expirationDate != null ? widget.expirationDate.day < currentTime.day : false;
      if (shouldRemoveWidget) {
        someWidgetsWereRemoved = true;
      }
      return shouldRemoveWidget;
    });
    if (someWidgetsWereRemoved) {
      await SharedPref.save(UrlsPreferences.KEY, jsonEncode(_urlsPreferences.toJson()));
      notifyListeners();
    }
  }

  Future<void> fetchConfig() async {
    final response = await http.get('http://$_currentUrl/api/config');
    _config = Config.fromJson(json.decode(response.body) as Map<String, dynamic>);
    _boards = _config.boards.boardsById.entries.map((entry) => entry.value).toList();
    _lastNotificationUpdateUrl = _currentUrl;
    _lastNotificationUpdateWidgetsState = getAllWidgetsDeepCopy();

    if (_urlsPreferences.urls.containsKey(_currentUrl)) {
      _currentUrlPreferences = _urlsPreferences.urls[_currentUrl];
      await checkIfQuarantineExpirationDateHasExceeded();
    } else {
      _urlsPreferences.urls
          .putIfAbsent(_currentUrl, () => new UrlPreferences(favouriteWidgets: [], quarantineWidgets: []));
      _currentUrlPreferences = _urlsPreferences.urls[_currentUrl];
      await SharedPref.save(UrlsPreferences.KEY, jsonEncode(_urlsPreferences.toJson()));
    }
    notifyListeners();
  }

  int get snackBarsToRemove => _snackBarsToRemove;

  bool get webSocketConnectionErrorPresent => _webSocketConnectionErrorPresent;

  String get notificationPayload => _notificationPayload;

  Board get currentBoard => _currentBoard;

  List<DashboardWidget> get favouriteWidgets {
    return _currentUrlPreferences.favouriteWidgets;
  }

  List<DashboardWidget> get quarantineWidgets {
    return _currentUrlPreferences.quarantineWidgets;
  }

  bool isWidgetInQuarantine(DashboardWidget widget) {
    return quarantineWidgets.indexWhere((element) => element.id == widget.id) > -1;
  }

  List<Board> get boards {
    return [..._boards];
  }

  List<DashboardWidget> getAllWidgets() {
    return _config.widgets.widgetsById.entries.map((entry) => entry.value).toList();
  }

  List<DashboardWidget> getAllWidgetsDeepCopy() {
    return new List<DashboardWidget>.from(getAllWidgets().map((widget) => DashboardWidget.deepCopy(widget)).toList());
  }

  List<DashboardWidget> getBoardWidgets(Board board) {
    return [
      ..._config.widgets.widgetsById.entries
          .map((entry) => entry.value)
          .where((widget) =>
              board.widgets.contains(widget.id) &&
              quarantineWidgets.indexWhere((element) => element.id == widget.id) == -1)
          .toList()
    ];
  }

  String getWidgetName(DashboardWidget widget) {
    return (widget.title != null && widget.title.isNotEmpty) ? widget.title : widget.type;
  }

  void updateWidget(Map<String, dynamic> widgetData) {
    if (_config != null) {
      _config.widgets.widgetsById.forEach((key, value) {
        if (key == widgetData['id']) {
          value.updateWidget(widgetData);
          notifyListeners();
        }
      });
    }
  }

  Future<void> updateFavouriteWidget(DashboardWidget widget) async {
    if (favouriteWidgets.contains(widget)) {
      await removeFavouriteWidget(widget);
    } else {
      await addFavouriteWidget(widget);
    }
  }

  Future<void> updateQuarantineWidget(DashboardWidget widget) async {
    if (quarantineWidgets.contains(widget)) {
      await removeQuarantineWidget(widget);
    } else {
      await addQuarantineWidget(widget);
    }
  }

  Future<void> addFavouriteWidget(DashboardWidget widget) async {
    _currentUrlPreferences.favouriteWidgets.add(widget);
    await SharedPref.save(UrlsPreferences.KEY, jsonEncode(_urlsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> addQuarantineWidget(DashboardWidget widget) async {
    _currentUrlPreferences.quarantineWidgets.add(widget);
    await SharedPref.save(UrlsPreferences.KEY, jsonEncode(_urlsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> removeFavouriteWidget(DashboardWidget widget) async {
    _currentUrlPreferences.favouriteWidgets.removeWhere((favouriteWidget) => favouriteWidget.id == widget.id);
    await SharedPref.save(UrlsPreferences.KEY, jsonEncode(_urlsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> removeQuarantineWidget(DashboardWidget widget) async {
    _currentUrlPreferences.quarantineWidgets.removeWhere((quarantineWidget) => quarantineWidget.id == widget.id);
    await SharedPref.save(UrlsPreferences.KEY, jsonEncode(_urlsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> removeQuarantineWidgets() async {
    _currentUrlPreferences.quarantineWidgets = [];
    await SharedPref.save(UrlsPreferences.KEY, jsonEncode(_urlsPreferences.toJson()));
    notifyListeners();
  }

  void addSnackBarToRemove() {
    _snackBarsToRemove++;
  }

  void markSnackBarAsRemoved() {
    _snackBarsToRemove--;
  }

  void setWebSocketConnectionErrorPresent() {
    _webSocketConnectionErrorPresent = true;
    notifyListeners();
  }

  bool shouldNotify() {
    if (_currentUrl != _lastNotificationUpdateUrl) {
      _lastNotificationUpdateUrl = _currentUrl;
      _lastNotificationUpdateWidgetsState = getAllWidgetsDeepCopy();
      return false;
    } else {
      bool shouldNotify = false;
      getAllWidgets().forEach((widget) {
        if (quarantineWidgets.indexWhere((element) => element.id == widget.id) == -1) {
          DashboardWidget notificationStateWidget =
              _lastNotificationUpdateWidgetsState.firstWhere((element) => element.id == widget.id);
          if (widget.content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
            WidgetStatus widgetStatus =
                EnumToString.fromString(WidgetStatus.values, widget.content[DashboardWidget.WIDGET_STATUS_KEY]);
            if (isErrorWidgetStatus(widgetStatus)) {
              if (notificationStateWidget.content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
                WidgetStatus notificationStateWidgetStatus = EnumToString.fromString(
                    WidgetStatus.values, notificationStateWidget.content[DashboardWidget.WIDGET_STATUS_KEY]);
                if (widgetStatus != notificationStateWidgetStatus) {
                  updateWidgetsInNotificationPayload(widget);
                  shouldNotify = true;
                }
              } else {
                shouldNotify = true;
              }
            }
          }
        }
      });
      if (shouldNotify) {
        setNotificationPayload();
      }
      _lastNotificationUpdateWidgetsState = getAllWidgetsDeepCopy();
      return shouldNotify;
    }
  }

  void updateWidgetsInNotificationPayload(DashboardWidget widget) {
    DashboardWidget notificationWidgetToUpdate =
        _widgetsInNotificationPayload.firstWhere((element) => element.id == widget.id, orElse: () => null);
    if (notificationWidgetToUpdate == null) {
      _widgetsInNotificationPayload.add(DashboardWidget.deepCopy(widget));
    } else {
      notificationWidgetToUpdate.content = new Map<String, dynamic>.from(widget.content);
    }
  }

  bool isErrorWidgetStatus(WidgetStatus widgetStatus) {
    return widgetStatus == WidgetStatus.CHECKBOX_FAIL ||
        widgetStatus == WidgetStatus.ERROR ||
        widgetStatus == WidgetStatus.ERROR_CONFIGURATION ||
        widgetStatus == WidgetStatus.ERROR_CONNECTION ||
        widgetStatus == WidgetStatus.FAIL;
  }

  void setNotificationPayload() {
    _notificationPayload = '';
    _widgetsInNotificationPayload.forEach((widget) {
      if (widget.content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
        _notificationPayload +=
            '${getWidgetName(widget)} has changed status to ${widget.content[DashboardWidget.WIDGET_STATUS_KEY]}\n';
      }
    });
  }

  void removeWidgetsInNotificationPayload() {
    _widgetsInNotificationPayload = [];
  }

  void setCurrentBoard(Board board) {
    this._currentBoard = board;
  }
}
