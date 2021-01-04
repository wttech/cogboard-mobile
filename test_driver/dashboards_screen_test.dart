// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'screens/dashboards_screen.dart';
import 'screens/login_screen.dart';
import 'screens/new_connection_screen.dart';

void main() {
  group('Dashboard Screen', () {

    final projectName = "Cogboard Mobile";
    final url = "150.254.30.119";
    final widget_id = "widget_TextWidget_widget9";
    FlutterDriver driver;
    LoginScreen loginScreen;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      loginScreen = new LoginScreen(driver);
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('check flutter driver health', () async {
      final health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

    test('Add new connection', () async {
      NewConnectionScreen newConnectionScreen = loginScreen.addFirstConnection();
      await newConnectionScreen.addNewConnection(projectName, url);
      expect(await loginScreen.getAddConnectionButtonText(), "+");
      expect(await loginScreen.getConnectButtonText(), "CONNECT");
      expect(await loginScreen.getProjectName(), "Cogboard M...");
      DashboardsScreen dashboardsScreen = loginScreen.goToDashboardsScreen();
      await dashboardsScreen.confirmHint();
      await dashboardsScreen.confirmHint();
    });

    test('Add widget to favourites', () async {
      DashboardsScreen dashboardsScreen = new DashboardsScreen(driver);
      expect(await dashboardsScreen.getWidgetTitle(widget_id), "TextWidget");
      await dashboardsScreen.confirmWidgetScreenHint(widget_id);
      await dashboardsScreen.addWidgetToFavourites(widget_id);
      expect(await dashboardsScreen.findWidgetInFavourites(widget_id), "TextWidget");
    });

    test('Add widget to quarantine', () async {
      DashboardsScreen dashboardsScreen = new DashboardsScreen(driver);
      await dashboardsScreen.addWidgetToQuarantine(widget_id);
      expect(await dashboardsScreen.findWidgetInQuarantine(widget_id), "TextWidget");
    });







  });
}
