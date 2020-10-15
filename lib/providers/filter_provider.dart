import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  bool _warningFilterPresent = false;
  bool _errorFilterPresent = false;

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
}