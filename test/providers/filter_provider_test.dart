import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/filter_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('filter provider tests', () {
    test('should get filtered error widget list', () async {
      // given
      FilterProvider filterProvider = new FilterProvider();
      List<DashboardWidget> widgetList = prepareWidgetListToFilter();

      // when
      filterProvider.toggleErrorFilter();
      List<DashboardWidget> filteredList = filterProvider.getFilteredWidgetList(widgetList);

      // then
      expect(filteredList.length, 1);
      expect(filteredList.first.id, '3');
    });

    test('should get filtered warning widget list', () async {
      // given
      FilterProvider filterProvider = new FilterProvider();
      List<DashboardWidget> widgetList = prepareWidgetListToFilter();

      // when
      filterProvider.toggleWarningFilter();
      List<DashboardWidget> filteredList = filterProvider.getFilteredWidgetList(widgetList);

      // then
      expect(filteredList.length, 1);
      expect(filteredList.first.id, '2');
    });

    test('should get filtered warning or error widget list', () async {
      // given
      FilterProvider filterProvider = new FilterProvider();
      List<DashboardWidget> widgetList = prepareWidgetListToFilter();

      // when
      filterProvider.toggleWarningFilter();
      filterProvider.toggleErrorFilter();
      List<DashboardWidget> filteredList = filterProvider.getFilteredWidgetList(widgetList);

      // then
      expect(filteredList.length, 2);
      expect(filteredList[0].id, '2');
      expect(filteredList[1].id, '3');
    });

    test('should filter view be reset', () async {
      // given
      FilterProvider filterProvider = new FilterProvider();

      // when
     filterProvider.resetFilterView();

      // then
      expect(filterProvider.shouldResetFilterView, true);
    });

    test('should shouldResetFilterView be set to false when markRestarted', () async {
      // given
      FilterProvider filterProvider = new FilterProvider();

      // when
      filterProvider.markRestarted();

      // then
      expect(filterProvider.shouldResetFilterView, false);
    });
  });
}

List<DashboardWidget> prepareWidgetListToFilter() {
  List<DashboardWidget> widgetList = new List<DashboardWidget>();
  DashboardWidget widget1 = new DashboardWidget(
    id: '1',
    content: {
      "widgetStatus": 'OK',
    },
  );
  DashboardWidget widget2 = new DashboardWidget(id: '2',
    content: {
      "widgetStatus": 'UNSTABLE',
    },);
  DashboardWidget widget3 = new DashboardWidget(id: '3',
    content: {
      "widgetStatus": 'ERROR',
    },);
  widgetList.add(widget1);
  widgetList.add(widget2);
  widgetList.add(widget3);
  return widgetList;
}
