// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'screens/login_screen.dart';
import 'screens/new_connection_screen.dart';
import 'screens/projects_screen.dart';

void main() {
  group('Login Screen', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // // be the same as the Strings we used for the Keys in step 1.
    final noConnectionTextFinder = find.byValueKey('urlSelectNoConnections');
    final addNewConnectionButtonFinder = find.byValueKey('loginScreenAddNewConnectionButton');
    final addConnectionScreenNameTextFormFinder = find.byValueKey('addConnectionNameTextForm');
    final addConnectionScreenUrlTextFormFinder = find.byValueKey('addConnectionUrlTextForm');
    final addConnectionScreenButtonFinder = find.byValueKey('addConnectionButton');
    final loginScreenAddButton = find.byValueKey('loginScreenAddButton');
    final loginScreenConnectButton = find.byValueKey('loginScreenConnectButton');
    final addConnectionScreenBackButton = find.byValueKey('addConnectionScreenBackButton');
    final projectName = "Cogboard Mobile";
    final url = "150.254.30.119";
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

    test('No connections', () async {
      expect(await loginScreen.getWelcomeText(), "Welcome. Start by adding a connection.");
    });

    test('Empty field test', () async {
      NewConnectionScreen newConnectionScreen = loginScreen.addFirstConnection();
      newConnectionScreen.addConnection();
      final emptyFormFieldErrorMessage = find.text('This field is required');
      await driver.waitFor(emptyFormFieldErrorMessage);
      await newConnectionScreen.backToLoginScreen();
    });

    test('Add new connection', () async {
      NewConnectionScreen newConnectionScreen = loginScreen.addFirstConnection();
      await newConnectionScreen.addNewConnection(projectName, url);
      expect(await loginScreen.getAddConnectionButtonText(), "+");
      expect(await loginScreen.getConnectButtonText(), "CONNECT");
      expect(await loginScreen.getProjectName(), "Cogboard M...");
    });

    test('Check duplicate error', () async {
      NewConnectionScreen newConnectionScreen = loginScreen.addConnection();
      newConnectionScreen.addNewConnection(projectName, url);
      final addConnectionErrorDuplicateName = find.text('This connection name is occupied.');
      await driver.waitFor(addConnectionErrorDuplicateName);
      await newConnectionScreen.backToLoginScreen();
    });

    test('Check Projects Screen', () async {
      ProjectsScreen projectsScreen = loginScreen.goToProjectsScreen();
      expect(await projectsScreen.getProjectName(projectName), projectName);
      expect(await projectsScreen.getProjectUrl(url), url);
      await projectsScreen.tapOnProject(projectName, '0');
    });

    // test('Add new Connection Test', () async {
    //   final loginScreen = new LoginScreen(driver);
    //   loginScreen.addFirstConnection();
    // await driver.tap(addNewConnectionButtonFinder);
    // await driver.tap(addConnectionScreenButtonFinder);
    // final addConnectionErrorNameField = find.text('This field is required');
    // await driver.waitFor(addConnectionErrorNameField);
    // await driver.tap(addConnectionScreenNameTextFormFinder);
    // await driver.enterText("Cogboard Mobile");
    // await driver.waitFor(find.text('Cogboard Mobile'));
    // await driver.tap(addConnectionScreenUrlTextFormFinder);
    // await driver.enterText("150.254.30.119");
    // await driver.waitFor(find.text('150.254.30.119'));
    // await driver.tap(addConnectionScreenButtonFinder);
    // final newConnectionScreen = new NewConnectionScreen(driver);
    // newConnectionScreen.addNewConnection();
    // expect(await loginScreen.addConnectionButtonText, "+");
    // expect(await loginScreen.connectButtonText, "CONNECT");
    // });

    // test('Add duplicate project name Test', () async {
    //   await driver.tap(loginScreenAddButton);
    //   await driver.tap(addConnectionScreenNameTextFormFinder);
    //   await driver.enterText("Cogboard Mobile");
    //   await driver.waitFor(find.text('Cogboard Mobile'));
    //   await driver.tap(addConnectionScreenUrlTextFormFinder);
    //   await driver.enterText("150.254.30.119");
    //   await driver.waitFor(find.text('150.254.30.119'));
    //   await driver.tap(addConnectionScreenButtonFinder);
    //   final addConnectionErrorDuplicateName = find.text('This connection name is occupied.');
    //   await driver.waitFor(addConnectionErrorDuplicateName);
    //   await driver.tap(addConnectionScreenBackButton);
    // });

    // test('Widget Board Test', () async {
    //   await driver.tap(loginScreenConnectButton);
    //   await driver.tap(find.byValueKey('dashboardScreenHintsConfirmButton'));
    //   await driver.tap(find.byValueKey('dashboardScreenHintsConfirmButton'));
    // });
  });
}
