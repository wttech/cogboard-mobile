import 'dart:async';
import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/config_model.dart';
import 'package:cogboardmobileapp/models/settings_preferences_model.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/utils/shared_preferences_utils.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConfigProvider with ChangeNotifier {
  Config _config;
  List<Board> _boards;
  SettingsPreferences _settingsPreferences;
  int _snackBarsToRemove = 0;
  bool _webSocketConnectionErrorPresent = false;
  List<DashboardWidget> _lastNotificationUpdateWidgetsState;
  String _notificationPayload;
  List<DashboardWidget> _widgetsInNotificationPayload = [];
  Board _currentBoard;

  ConfigProvider() {
    fetchSettingsPreferences();
    new Timer.periodic(const Duration(minutes: 1), everyMinuteCheckTimer);
  }

  ConfigProvider withSettingsPreferences(SettingsPreferences settingsPreferences) {
    _settingsPreferences = settingsPreferences;
    notifyListeners();
    return this;
  }

  Future<void> fetchSettingsPreferences() async {
    if (await SharedPref.containsKey(SettingsPreferences.KEY)) {
      _settingsPreferences = SettingsPreferences.fromJson(jsonDecode(await SharedPref.read(SettingsPreferences.KEY)));
      if (_settingsPreferences.version == null ||
          (_settingsPreferences.version != null && _settingsPreferences.version < SettingsPreferences.VERSION)) {
        await createSettingsPreferences();
      }
    } else {
      await createSettingsPreferences();
    }
  }

  Future createSettingsPreferences() async {
    _settingsPreferences = new SettingsPreferences(
        connections: [],
        version: SettingsPreferences.VERSION,
        showHints: true,
        sortBy: WidgetSortTypes.NONE,
        showNotifications: true,
        notificationFrequencyInMinutes: 1);
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
  }

  void everyMinuteCheckTimer(Timer timer) async {
    if (currentConnectionPreferences != null) {
      await checkIfQuarantineExpirationDateHasExceeded();
    }
  }

  Future<void> checkIfQuarantineExpirationDateHasExceeded() async {
    DateTime currentTime = new DateTime.now();
    bool someWidgetsWereRemoved = false;
    currentConnectionPreferences.quarantineWidgets.removeWhere((widget) {
      bool shouldRemoveWidget = widget.expirationDate != null ? widget.expirationDate.day < currentTime.day : false;
      if (shouldRemoveWidget) {
        someWidgetsWereRemoved = true;
      }
      return shouldRemoveWidget;
    });
    if (someWidgetsWereRemoved) {
      await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
      notifyListeners();
    }
  }

  Future<void> fetchConfig() async {
    final response = await http.get('http://$currentUrl/api/config');
    _config = Config.fromJson(json.decode(response.body) as Map<String, dynamic>);
    _boards = _config.boards.boardsById.entries.map((entry) => entry.value).toList();
    _lastNotificationUpdateUrl = currentUrl;
    _lastNotificationUpdateWidgetsState = getAllWidgetsDeepCopy();
    await checkIfQuarantineExpirationDateHasExceeded();
    notifyListeners();
  }

  String get currentUrl => _settingsPreferences.currentConnection.connectionUrl;

  ConnectionPreferences get currentConnectionPreferences => _settingsPreferences.currentConnection;

  int get snackBarsToRemove => _snackBarsToRemove;

  bool get webSocketConnectionErrorPresent => _webSocketConnectionErrorPresent;

  String get notificationPayload => _notificationPayload;

  Board get currentBoard => _currentBoard;

  int get notificationFrequency => _settingsPreferences.notificationFrequencyInMinutes;

  DateTime get lastNotificationTimestamp => _settingsPreferences.lastNotificationTimestamp;

  get showNotifications => _settingsPreferences.showNotifications;

  List<DashboardWidget> get favouriteWidgets {
    return getSortedWidgetsList(currentConnectionPreferences.favouriteWidgets);
  }

  List<DashboardWidget> get quarantineWidgets {
    return getSortedWidgetsList(currentConnectionPreferences.quarantineWidgets);
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

  String getWidgetName(DashboardWidget widget) {
    return (widget.title != null && widget.title.isNotEmpty) ? widget.title : widget.type;
  }

  List<DashboardWidget> getBoardWidgets(Board board) {
    List<DashboardWidget> boardWidgets = [
      ..._config.widgets.widgetsById.entries
          .map((entry) => entry.value)
          .where((widget) =>
              board.widgets.contains(widget.id) &&
              quarantineWidgets.indexWhere((element) => element.id == widget.id) == -1 &&
              widget.type != "WhiteSpaceWidget")
          .toList()
    ];
    return getSortedWidgetsList(boardWidgets);
  }

  List<DashboardWidget> getSortedWidgetsList(List<DashboardWidget> boardWidgets) {
    switch (_settingsPreferences.sortBy) {
      case WidgetSortTypes.NONE:
        return boardWidgets;
      case WidgetSortTypes.NAME_ASCENDING:
        boardWidgets.sort((a, b) => getWidgetName(a).compareTo(getWidgetName(b)));
        break;
      case WidgetSortTypes.NAME_DESCENDING:
        boardWidgets.sort((a, b) => getWidgetName(a).compareTo(getWidgetName(b)));
        boardWidgets = boardWidgets.reversed.toList();
        break;
      case WidgetSortTypes.STATUS_ASCENDING:
        boardWidgets.sort((a, b) => sortWidgetsByStatus(a, b));
        break;
      case WidgetSortTypes.STATUS_DESCENDING:
        boardWidgets.sort((a, b) => sortWidgetsByStatus(a, b));
        boardWidgets = boardWidgets.reversed.toList();
        break;
    }
    return boardWidgets;
  }

  int sortWidgetsByStatus(DashboardWidget a, DashboardWidget b) {
    int firstWidgetStatusSortValue = widgetStatusSortValue(a);
    int secondWidgetStatusSortValue = widgetStatusSortValue(b);
    if (firstWidgetStatusSortValue == secondWidgetStatusSortValue) {
      return getWidgetName(a).compareTo(getWidgetName(b));
    } else {
      return firstWidgetStatusSortValue > secondWidgetStatusSortValue ? 1 : -1;
    }
  }

  int widgetStatusSortValue(DashboardWidget widget) {
    if (widget.content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
      WidgetStatus widgetStatus =
          EnumToString.fromString(WidgetStatus.values, widget.content[DashboardWidget.WIDGET_STATUS_KEY]);
      switch (widgetStatus) {
        case WidgetStatus.OK:
          return 1;
        case WidgetStatus.UNSTABLE:
          return 5;
        case WidgetStatus.FAIL:
          return 6;
        case WidgetStatus.UNKNOWN:
          return 4;
        case WidgetStatus.IN_PROGRESS:
          return 2;
        case WidgetStatus.ERROR_CONFIGURATION:
          return 6;
        case WidgetStatus.ERROR:
          return 6;
        case WidgetStatus.ERROR_CONNECTION:
          return 6;
        case WidgetStatus.TRANSPARENT:
          return 2;
        case WidgetStatus.CHECKBOX_OK:
          return 1;
        case WidgetStatus.CHECKBOX_FAIL:
          return 6;
        case WidgetStatus.CHECKBOX_UNKNOWN:
          return 4;
        case WidgetStatus.NONE:
          return 3;
        default:
          return 3;
      }
    } else {
      return 3;
    }
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
    currentConnectionPreferences.favouriteWidgets.add(widget);
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> addQuarantineWidget(DashboardWidget widget) async {
    currentConnectionPreferences.quarantineWidgets.add(widget);
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> updateNotificationTimestamp() async {
    _settingsPreferences.lastNotificationTimestamp = new DateTime.now();
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
  }

  Future<void> removeFavouriteWidget(DashboardWidget widget) async {
    currentConnectionPreferences.favouriteWidgets.removeWhere((favouriteWidget) => favouriteWidget.id == widget.id);
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> removeQuarantineWidget(DashboardWidget widget) async {
    currentConnectionPreferences.quarantineWidgets.removeWhere((quarantineWidget) => quarantineWidget.id == widget.id);
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
    notifyListeners();
  }

  Future<void> removeQuarantineWidgets() async {
    currentConnectionPreferences.quarantineWidgets = [];
    await SharedPref.save(SettingsPreferences.KEY, jsonEncode(_settingsPreferences.toJson()));
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
    if (!(showNotifications && (lastNotificationTimestamp == null || enoughTimeHavePassed()))) {
      return false;
    }
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

  bool enoughTimeHavePassed() =>
      new DateTime.now().isAfter(lastNotificationTimestamp.add(new Duration(minutes: notificationFrequency)));

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
