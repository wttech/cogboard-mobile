import 'package:flutter_driver/flutter_driver.dart';

class NewConnectionScreen {
  final nameTextFormFinder = find.byValueKey('addConnectionNameTextForm');
  final urlTextFormFinder = find.byValueKey('addConnectionUrlTextForm');
  final addConnectionButtonFinder = find.byValueKey('addConnectionButton');
  final backButtonFinder = find.byValueKey('addConnectionScreenBackButton');

  FlutterDriver driver;

  NewConnectionScreen(this.driver);

  Future<Null> addNewConnection(String projectName, String url) async {
    await driver.tap(nameTextFormFinder);
    await driver.enterText(projectName);
    await driver.waitFor(find.text(projectName));
    await driver.tap(urlTextFormFinder);
    await driver.enterText(url);
    await driver.waitFor(find.text(url));
    addConnection();
  }

  Future<Null> addConnection() async {
    await driver.tap(addConnectionButtonFinder);
  }

  Future<Null> backToLoginScreen() async {
    await driver.tap(backButtonFinder);
  }
}
