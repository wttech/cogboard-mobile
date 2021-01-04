import 'package:flutter_driver/flutter_driver.dart';

class DashboardsScreen {
  final _dashboardHintConfirmButtonFinder = find.byValueKey('dashboardScreenHintsConfirmButton');
  FlutterDriver driver;

  DashboardsScreen(this.driver);

  Future<Null> confirmHint() async {
    await driver.tap(_dashboardHintConfirmButtonFinder);
  }

  Future<String> getWidgetTitle(String widgetId) async {
    await driver.waitFor(find.byValueKey('${widgetId}_title'));
    return await driver.getText(find.byValueKey('${widgetId}_title'));
  }

  Future<Null> confirmWidgetScreenHint(String widgetId) async {
    await driver.tap(find.byValueKey(widgetId));
    await driver.tap(find.byValueKey('widgetScreenHintConfirmButton'));
    await driver.tap(find.pageBack());
  }

  Future<Null> addWidgetToFavourites(String widgetId) async {
    await driver.tap(find.text('Home'));
    await driver.tap(find.byValueKey(widgetId));
    await driver.tap(find.byValueKey('widgetScreenFavouriteButton'));
    await driver.tap(find.pageBack());
  }

  Future<String> findWidgetInFavourites(String widgetId) async {
    await driver.tap(find.text('Favourites'));
    await driver.tap(find.byValueKey('widgetListScreenHintConfirmButton'));
    return await getWidgetTitle(widgetId);
  }

  Future<Null> addWidgetToQuarantine(String widgetId) async {
    await driver.tap(find.text('Home'));
    await driver.tap(find.byValueKey(widgetId));
    await driver.tap(find.byValueKey('widgetScreenQuarantineButton'));
    await driver.tap(find.byValueKey('widgetScreenQuarantineDialogWithoutButton'));
  }

  Future<String> findWidgetInQuarantine(String widgetId) async {
    await driver.waitForAbsent(find.byValueKey(widgetId));
    await driver.tap(find.text('Quarantine'));
    return await getWidgetTitle(widgetId);
  }

}
