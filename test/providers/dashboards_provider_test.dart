import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dashboards provider tests', () {
    test('should dashboard tab index be set', () async {
      // given
      DashboardsProvider dashboardsProvider = new DashboardsProvider();

      // when
      dashboardsProvider.setDashboardTabIndex(2);

      // then
      expect(dashboardsProvider.dashboardTabIndex, 2);
    });
  });
}
