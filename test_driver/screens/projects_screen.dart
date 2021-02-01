import 'package:flutter_driver/flutter_driver.dart';

class ProjectsScreen {

  FlutterDriver driver;

  ProjectsScreen(this.driver);

  Future<String> getProjectName(String projectName) async {
    final projectNameFinder = find.byValueKey('item_${projectName}_name');
    return await driver.getText(projectNameFinder);
  }

  Future<String> getProjectUrl(String projectUrl) async {
    final projectUrlFinder = find.byValueKey('item_${projectUrl}_url');
    return await driver.getText(projectUrlFinder);
  }

  Future<Null> tapOnProject(String projectName, String id) async {
    final projectListTileFinder = find.byValueKey('${projectName}_${id}');
    await driver.tap(projectListTileFinder);
  }

}
