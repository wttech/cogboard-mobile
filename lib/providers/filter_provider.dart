import 'package:cogboardmobileapp/models/widget_model.dart';
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
        return widget.isWarningOrError();
      } else if (this.isWarningFilterPresent) {
        return widget.isWarning();
      } else if (this.isErrorFilterPresent) {
        return widget.isError();
      } else {
        return true;
      }
    }).toList();
  }

  void resetFilterView() {
    _shouldResetFilterView = true;
    notifyListeners();
  }

  void markRestarted() {
    _shouldResetFilterView = false;
  }
}
