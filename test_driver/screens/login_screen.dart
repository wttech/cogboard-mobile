import 'dart:typed_data';

import 'package:flutter_driver/flutter_driver.dart';
import 'dashboards_screen.dart';
import 'new_connection_screen.dart';
import 'projects_screen.dart';

class LoginScreen {
  final _noConnectionsTextFinder = find.byValueKey('urlSelectNoConnections');
  final _addFirstConnectionButtonFinder = find.byValueKey('loginScreenAddNewConnectionButton');
  final _addConnectionButtonFinder = find.byValueKey('loginScreenAddButton');
  final _connectButtonFinder = find.byValueKey('loginScreenConnectButton');
  final _projectNameFinder = find.byValueKey('loginScreenUrlSelectWidget');
  final _projectsScreenButtonFinder = find.byValueKey('loginScreenUrlSelectButton');

  final FlutterDriver driver;

  LoginScreen(this.driver);

  Future<bool> get isReady {
    return driver.waitFor(_noConnectionsTextFinder).then((_) => true).catchError((_) => false);
  }

  Future<String> getWelcomeText() async {
    return await driver.getText(_noConnectionsTextFinder);
  }

  Future<String> getAddConnectionButtonText() async {
    return await driver.getText(_addConnectionButtonFinder);
  }

  Future<String> getConnectButtonText() async {
    return await driver.getText(_connectButtonFinder);
  }

  Future<String> getProjectName() async {
    return await driver.getText(_projectNameFinder);
  }

  NewConnectionScreen addFirstConnection() {
    driver.tap(_addFirstConnectionButtonFinder);
    return new NewConnectionScreen(driver);
  }

  NewConnectionScreen addConnection() {
    driver.tap(_addConnectionButtonFinder);
    return new NewConnectionScreen(driver);
  }

  ProjectsScreen goToProjectsScreen() {
    driver.tap(_projectsScreenButtonFinder);
    return new ProjectsScreen(driver);
  }

  DashboardsScreen goToDashboardsScreen() {
    driver.tap(_connectButtonFinder);
    return new DashboardsScreen(driver);
  }
}
