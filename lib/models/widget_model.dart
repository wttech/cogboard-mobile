import 'package:cogboardmobileapp/models/widget_config_model.dart';

class WidgetStatus {
  static const String OK = "OK";
  static const String UNSTABLE = "UNSTABLE";
  static const String FAIL = "FAIL";
  static const String UNKNOWN = "UNKNOWN";
  static const String IN_PROGRESS = "IN_PROGRESS";
  static const String ERROR_CONFIGURATION = "ERROR_CONFIGURATION";
  static const String ERROR = "ERROR";
  static const String ERROR_CONNECTION = "ERROR_CONNECTION";
  static const String TRANSPARENT = "TRANSPARENT";
  static const String CHECKBOX_OK = "CHECKBOX_OK";
  static const String CHECKBOX_FAIL = "CHECKBOX_FAIL";
  static const String CHECKBOX_UNKNOWN = "CHECKBOX_FAIL";
  static const String NONE = "NONE";
}

class DashboardWidget {
  String id;
  String title;
  String type;
  WidgetConfig config;
  bool disabled;
  Map<String, dynamic> content;

  DashboardWidget({this.id, this.title, this.type, this.config, this.disabled, this.content});

  factory DashboardWidget.fromJson(Map<String, dynamic> json) => DashboardWidget(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      config: WidgetConfig.fromJson(json['config']),
      disabled: json['disabled'],
      content: (json['content']) as Map<String, dynamic>);

  void updateWidget(Map<String, dynamic> json) {
    this.id = json['id'] ?? this.id;
    this.title = json['title'] ?? this.title;
    this.type = json['type'] ?? this.type;
    this.config = json['config'] != null ? WidgetConfig.fromJson(json['config']) : this.config;
    this.disabled = json['disabled'] ?? this.disabled;
    this.content = json['content'] != null ? (json['content']) as Map<String, dynamic> : this.content;
  }
}
