import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  bool _warningFilterPresent = false;
  bool _errorFilterPresent = false;
  bool _shouldResetFilterView = false;

  bool get shouldResetFilterView {
    return _shouldResetFilterView;
  }

  bool get isWarningFilterPresent {
    return _warningFilterPresent;
  }

  bool get isErrorFilterPresent {
    return _errorFilterPresent;
  }

  bool get isAnyFilterPresent {
    return isWarningFilterPresent || isErrorFilterPresent;
  }

  void toggleWarningFilter() {
    _warningFilterPresent = !_warningFilterPresent;
    notifyListeners();
  }

  void toggleErrorFilter() {
    _errorFilterPresent = !_errorFilterPresent;
    notifyListeners();
  }

  List<DashboardWidget> getFilteredWidgetList(List<DashboardWidget> widgetList) {
    return widgetList.where((widget) {
      if (this.isWarningFilterPresent && this.isErrorFilterPresent) {
        return this.isWarningOrErrorWidget(widget);
      } else if (this.isWarningFilterPresent) {
        return isWarningWidget(widget);
      } else if (this.isErrorFilterPresent) {
        return isErrorWidget(widget);
      } else {
        return true;
      }
    }).toList();
  }

  bool isWarningOrErrorWidget(DashboardWidget widget) {
    return isWarningWidget(widget) || isErrorWidget(widget);
  }

  bool isWarningWidget(DashboardWidget widget) {
    if (widget.content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
      final WidgetStatus widgetStatus =
          EnumToString.fromString(WidgetStatus.values, widget.content[DashboardWidget.WIDGET_STATUS_KEY]);
      return widgetStatus == WidgetStatus.CHECKBOX_UNKNOWN ||
          widgetStatus == WidgetStatus.UNKNOWN ||
          widgetStatus == WidgetStatus.UNSTABLE;
    } else {
      return false;
    }
  }

  bool isErrorWidget(DashboardWidget widget) {
    if (widget.content.containsKey(DashboardWidget.WIDGET_STATUS_KEY)) {
      final WidgetStatus widgetStatus =
          EnumToString.fromString(WidgetStatus.values, widget.content[DashboardWidget.WIDGET_STATUS_KEY]);
      return widgetStatus == WidgetStatus.CHECKBOX_FAIL ||
          widgetStatus == WidgetStatus.ERROR_CONNECTION ||
          widgetStatus == WidgetStatus.ERROR_CONFIGURATION ||
          widgetStatus == WidgetStatus.ERROR ||
          widgetStatus == WidgetStatus.FAIL;
    } else {
      return false;
    }
  }

  void resetFilterView() {
    _shouldResetFilterView = true;
    notifyListeners();
  }

  void markRestarted() {
    _shouldResetFilterView = false;
  }
}
