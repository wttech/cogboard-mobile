import 'package:cogboardmobileapp/models/widget_config_model.dart';

enum WidgetStatus {
  OK,
  UNSTABLE,
  FAIL,
  UNKNOWN,
  IN_PROGRESS,
  ERROR_CONFIGURATION,
  ERROR,
  ERROR_CONNECTION,
  TRANSPARENT,
  CHECKBOX_OK,
  CHECKBOX_FAIL,
  CHECKBOX_UNKNOWN,
  NONE
}

class DashboardWidget {
  String id;
  String title;
  String type;
  WidgetConfig config;
  bool disabled;
  Map<String, dynamic> content;
  DateTime expirationDate;

  static const WIDGET_STATUS_KEY = 'widgetStatus';

  DashboardWidget({this.id, this.title, this.type, this.config, this.disabled, this.content, this.expirationDate});

  factory DashboardWidget.fromJson(Map<String, dynamic> json) => DashboardWidget(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      config: WidgetConfig.fromJson(json['config']),
      disabled: json['disabled'],
      expirationDate: (json['expirationDate'] != "null" && json['expirationDate'] != null) ? DateTime.parse(json['expirationDate']): null,
      content: (json['content']) as Map<String, dynamic>);

  factory DashboardWidget.deepCopy(DashboardWidget dashboardWidget) => new DashboardWidget(
      id: dashboardWidget.id,
      title: dashboardWidget.title,
      type: dashboardWidget.type,
      config: WidgetConfig.deepCopy(dashboardWidget.config),
      disabled: dashboardWidget.disabled,
      content: new Map<String, dynamic>.from(dashboardWidget.content),
  );

  Map toJson() {
    return {
      "id": id,
      "title": title,
      "type": type,
      "config": config.toJson(),
      "disabled": disabled,
      "expirationDate": expirationDate.toString(),
      "content": content,
    };
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
