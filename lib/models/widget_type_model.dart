import 'package:flutter/cupertino.dart';

enum WidgetSortBy {
  None,
  Name,
  Status
}

class WidgetType {
  String name;
  bool isVisible;

  WidgetType({
    @required this.name,
    @required this.isVisible
  });


  Map<String, dynamic> toJson() => {
    'name': name,
    'isVisible': isVisible,
  };

  factory WidgetType.fromJson(Map<String, dynamic> json) {
    return WidgetType(
      name: json['name'],
      isVisible: json['isVisible'],
    );
  }

}