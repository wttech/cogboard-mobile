import 'package:cogboardmobileapp/models/widget_config_model.dart';
import 'package:enum_to_string/enum_to_string.dart';

enum WidgetStatus {
  OK,
  CHECKBOX_OK,
  IN_PROGRESS,
  TRANSPARENT,
  NONE,
  CHECKBOX_UNKNOWN,
  UNKNOWN,
  UNSTABLE,
  CHECKBOX_FAIL,
  FAIL,
  ERROR_CONFIGURATION,
  ERROR_CONNECTION,
  ERROR
}


class DashboardWidget {
  String id;
  String title;
  String type;
  WidgetConfig config;
  bool disabled;
  Map<String, dynamic> content;
  DateTime expirationDate;
  int maxValue;
  String selectedZabbixMetric;
  List range;
  List toDoListItems;

  static const WIDGET_STATUS_KEY = 'widgetStatus';

  DashboardWidget({
    this.id,
    this.title,
    this.type,
    this.config,
    this.disabled,
    this.content,
    this.expirationDate,
    this.maxValue,
    this.selectedZabbixMetric,
    this.range,
    this.toDoListItems,
  });

  factory DashboardWidget.fromJson(Map<String, dynamic> json) => DashboardWidget(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      config: WidgetConfig.fromJson(json['config']),
      disabled: json['disabled'],
      expirationDate:json['expirationDate'] != null ? DateTime.parse(json['expirationDate']) : null,
      maxValue: (json['maxValue']),
      selectedZabbixMetric: json['selectedZabbixMetric'],
      range: json['range'],
      toDoListItems: json['toDoListItems'],
      content: (json['content']) as Map<String, dynamic>);

  factory DashboardWidget.deepCopy(DashboardWidget dashboardWidget) => new DashboardWidget(
        id: dashboardWidget.id,
        title: dashboardWidget.title,
        type: dashboardWidget.type,
        config: WidgetConfig.deepCopy(dashboardWidget.config),
        disabled: dashboardWidget.disabled,
        maxValue: dashboardWidget.maxValue,
        selectedZabbixMetric: dashboardWidget.selectedZabbixMetric,
        range: dashboardWidget.range,
        toDoListItems: dashboardWidget.toDoListItems,
        content: new Map<String, dynamic>.from(dashboardWidget.content),
      );

  Map toJson() {
    return {
      "id": id,
      "title": title,
      "type": type,
      "config": config.toJson(),
      "disabled": disabled,
      "expirationDate": expirationDate != null ? expirationDate.toString() : null,
      "maxValue": maxValue,
      "selectedZabbixMetric": selectedZabbixMetric,
      "range": range,
      "toDoListItems": toDoListItems,
      "content": content,
    };
  }

  bool isWarning() {
    if (content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
      final WidgetStatus widgetStatus =
      EnumToString.fromString(WidgetStatus.values, content[DashboardWidget.WIDGET_STATUS_KEY]);
      return hasWarningStatus(widgetStatus);
    } else {
      return false;
    }
  }

  bool hasWarningStatus(WidgetStatus widgetStatus) {
    return widgetStatus == WidgetStatus.CHECKBOX_UNKNOWN ||
        widgetStatus == WidgetStatus.UNKNOWN ||
        widgetStatus == WidgetStatus.UNSTABLE;
  }

  bool isError() {
    if (content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
      final WidgetStatus widgetStatus =
      EnumToString.fromString(WidgetStatus.values, content[DashboardWidget.WIDGET_STATUS_KEY]);
      return hasErrorStatus(widgetStatus);
    } else {
      return false;
    }
  }

  bool hasErrorStatus(WidgetStatus widgetStatus) {
    return widgetStatus == WidgetStatus.CHECKBOX_FAIL ||
        widgetStatus == WidgetStatus.ERROR_CONNECTION ||
        widgetStatus == WidgetStatus.ERROR_CONFIGURATION ||
        widgetStatus == WidgetStatus.ERROR ||
        widgetStatus == WidgetStatus.FAIL;
  }


  bool isWarningOrError() {
    return isWarning() || isError();
  }

  void updateWidget(Map<String, dynamic> json) {
    this.id = json['id'] ?? this.id;
    this.title = json['title'] ?? this.title;
    this.type = json['type'] ?? this.type;
    this.config = json['config'] != null ? WidgetConfig.fromJson(json['config']) : this.config;
    this.disabled = json['disabled'] ?? this.disabled;
    this.content = json['content'] != null ? (json['content']) as Map<String, dynamic> : this.content;
  }
}
