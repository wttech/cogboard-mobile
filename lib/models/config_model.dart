import 'package:cogboardmobileapp/models/widgets_model.dart';

import 'boards_model.dart';

class Config {
  Boards boards;
  Widgets widgets;

  Config({
    this.boards,
    this.widgets
  });

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    boards: Boards.fromJson(json['boards']),
    widgets: Widgets.fromJson(json['widgets']),
  );
}