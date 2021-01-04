// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'screens/login_screen.dart';
import 'screens/new_connection_screen.dart';
import 'screens/projects_screen.dart';

void main() {
  group('Login Screen', () {
    final projectName = "Cogboard Mobile";
    final url = "150.254.30.119";
    FlutterDriver driver;
    LoginScreen loginScreen;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      loginScreen = new LoginScreen(driver);
    });

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
  });
}
