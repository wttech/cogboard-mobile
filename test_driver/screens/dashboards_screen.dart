import 'package:flutter_driver/flutter_driver.dart';

import 'widget_screen.dart';

class DashboardsScreen {
  final _dashboardHintConfirmButtonFinder = find.byValueKey('dashboardScreenHintsConfirmButton');
  final _widgetListHintConfirmButtonFinder = find.byValueKey('widgetListScreenHintConfirmButton');
  final _homeBottomButtonFinder = find.text('Home');
  final _favouritesBottomButtonFinder = find.text('Favourites');
  final _quarantineBottomButtonFinder = find.text('Quarantine');

  FlutterDriver driver;

  DashboardsScreen(this.driver);

  Future<Null> confirmHint() async {
    await driver.tap(_dashboardHintConfirmButtonFinder);
  }

  Future<String> getWidgetTitle(String widgetId) async {
    await driver.waitFor(find.byValueKey('${widgetId}_title'));
    return await driver.getText(find.byValueKey('${widgetId}_title'));
  }

  WidgetScreen tapWidget(String widgetId) {
    driver.tap(_homeBottomButtonFinder);
    driver.tap(find.byValueKey(widgetId));
    return WidgetScreen(driver);
  }

  Future<String> findWidgetInFavourites(String widgetId) async {
    await driver.tap(_favouritesBottomButtonFinder);
    await driver.tap(_widgetListHintConfirmButtonFinder);
    return await getWidgetTitle(widgetId);
  }

  Future<String> findWidgetInQuarantine(String widgetId) async {
    await driver.waitForAbsent(find.byValueKey(widgetId));
    await driver.tap(_quarantineBottomButtonFinder);
    return await getWidgetTitle(widgetId);
  }
}
