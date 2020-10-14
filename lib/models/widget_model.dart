import 'package:cogboardmobileapp/models/widget_config_model.dart';
import 'dart:convert';

class DashboardWidget {
  String id;
  String title;
  String type;
  WidgetConfig config;
  bool disabled;
  Map<String, dynamic> content;

  DashboardWidget({
    this.id,
    this.title,
    this.type,
    this.config,
    this.disabled,
    this.content
  });

  factory DashboardWidget.fromJson(Map<String, dynamic> json) => DashboardWidget(
    id: json['id'],
    title: json['title'],
    type: json['type'],
    config: WidgetConfig.fromJson(json['config']),
    disabled: json['disabled'],
    content: (json['content']) as Map<String, dynamic>
  );
}