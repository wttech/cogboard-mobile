import 'package:cogboardmobileapp/models/widget_config_model.dart';
import 'dart:convert';

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
