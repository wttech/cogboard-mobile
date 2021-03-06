class Board {
  String id;
  String title;
  int columns;
  bool autoSwitch;
  int switchInterval;
  List<String> widgets;
  String iframeUrl;
  String theme;
  String type;

  Board(
      {this.id,
      this.title,
      this.columns = 8,
      this.autoSwitch = false,
      this.switchInterval,
      this.widgets,
      this.iframeUrl,
      this.theme,
      this.type = 'WidgetBoard'});

  factory Board.fromJson(Map<String, dynamic> json) => Board(
        id: json['id'],
        title: json['title'],
        columns: json['columns'],
        autoSwitch: json['autoSwitch'],
        switchInterval: json['switchInterval'],
        widgets: ((json['widgets']) as List<dynamic>).cast<String>(),
        iframeUrl: json['iframeUrl'],
        theme: json['theme'],
        type: json['type'],
      );
}
