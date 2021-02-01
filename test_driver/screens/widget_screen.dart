import 'package:flutter_driver/flutter_driver.dart';

class WidgetScreen {
  final _hintConfirmButtonFinder = find.byValueKey('widgetScreenHintConfirmButton');
  final _favouriteButtonFinder = find.byValueKey('widgetScreenFavouriteButton');
  final _quarantineButtonFinder = find.byValueKey('widgetScreenQuarantineButton');
  final _quarantineDialogWithoutButtonFinder = find.byValueKey('widgetScreenQuarantineDialogWithoutButton');

  FlutterDriver driver;

  WidgetScreen(this.driver);

  Future<Null> confirmWidgetScreenHint(String widgetId) async {
    await driver.tap(_hintConfirmButtonFinder);
  }

  Future<Null> addWidgetToFavourites(String widgetId) async {
    await driver.tap(_favouriteButtonFinder);
    await driver.tap(find.pageBack());
  }

  Future<Null> addWidgetToQuarantine(String widgetId) async {
    await driver.tap(_quarantineButtonFinder);
    await driver.tap(_quarantineDialogWithoutButtonFinder);
  }
}
