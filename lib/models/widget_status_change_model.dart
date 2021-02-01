import 'package:cogboardmobileapp/models/widget_model.dart';

class WidgetStatusChange {
  DashboardWidget from;
  DashboardWidget to;
  WidgetStatusChange({this.from, this.to});
}