class WidgetConfig {
  int columns;
  dynamic rows;
  bool goNewLine;

  WidgetConfig({
    this.columns,
    this.rows,
    this.goNewLine
  });

  factory WidgetConfig.fromJson(Map<String, dynamic> json) => WidgetConfig(
    columns: json['columns'],
    rows: json['rows'],
    goNewLine: json['goNewLine'],
  );
}