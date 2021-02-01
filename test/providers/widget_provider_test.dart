import 'package:cogboardmobileapp/providers/widget_provider.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('widget provider tests', () {
    test('should widget status be set', () async {
      // given
      WidgetProvider widgetProvider = new WidgetProvider();

      // when
      widgetProvider.setWidgetStatus("new");

      // then
      expect(widgetProvider.widgetStatus, "new");
    });
  });
}


