import 'package:flutter/material.dart';

const StatusColors = {
  "TRANSPARENT": Colors.transparent,
  "CHECKBOX_OK": Color.fromRGBO(1, 148, 48, 1),
  "CHECKBOX_FAIL": Color.fromRGBO(225, 49, 47, 1),
  "CHECKBOX_UNKNOWN": Color.fromRGBO(38, 36, 62, 1),
  "NONE": Color.fromRGBO(38, 36, 62, 1),
  "UNKNOWN": Color.fromRGBO(38, 36, 62, 1),
  "DEFAULT": Color.fromRGBO(38, 36, 62, 1),
  "OK": Color.fromRGBO(1, 148, 48, 1),
  "IN_PROGRESS": Color.fromRGBO(25, 140, 189, 1),
  "UNSTABLE": Color.fromRGBO(255, 151, 36, 1),
  "ERROR_CONNECTION": Color.fromRGBO(225, 49, 47, 1),
  "ERROR_CONFIGURATION": Color.fromRGBO(225, 49, 47, 1),
  "ERROR": Color.fromRGBO(225, 49, 47, 1),
  "FAIL": Color.fromRGBO(225, 49, 47, 1)
};

const StatusCodes = {
  "ERROR": "ERROR",
  "ERROR_CONNECTION": "CONNECTION ERROR",
  "ERROR_CONFIGURATION": "MISCONFIGURED",
  "IN_PROGRESS": "IN PROGRESS",
  "OK": "SUCCESS",
  "UNKNOWN": "UNKNOWN",
  "UNSTABLE": "UNSTABLE",
  "FAIL": "FAILED"
};

const StatusIcons = {
  "ERROR": Icon(
    Icons.error_outline,
    color: Colors.white,
    size: 16.0,
  ),
  "ERROR_CONNECTION": Icon(
    Icons.error_outline,
    color: Colors.white,
    size: 16.0,
  ),
  "ERROR_CONFIGURATION": Icon(
    Icons.warning,
    color: Colors.white,
    size: 16.0,
  ),
  "IN_PROGRESS": Icon(
    Icons.sync,
    color: Colors.white,
    size: 16.0,
  ),
  "OK": Icon(
    Icons.check,
    color: Colors.white,
    size: 16.0,
  ),
  "UNKNOWN": Icon(
    Icons.help_outline,
    color: Colors.white,
    size: 16.0,
  ),
  "UNSTABLE": Icon(
    Icons.show_chart,
    color: Colors.white,
    size: 16.0,
  ),
  "FAIL": Icon(
    Icons.block,
    color: Colors.white,
    size: 16.0,
  ),
};

const CheckboxIcons = {
  "CHECKBOX_OK": Icon(
    Icons.check,
    color: Colors.white,
    size: 64.0,
  ),
  "CHECKBOX_FAIL": Icon(
    Icons.clear,
    color: Colors.white,
    size: 64.0,
  ),
  "CHECKBOX_UNKNOWN": Icon(
    Icons.remove,
    color: Colors.white,
    size: 64.0,
  ),
};

class WidgetTypes {
  static const String BAMBOO_PLAN_WIDGET = "BambooPlanWidget";
  static const String JENKINS_JOB_WIDGET = "JenkinsJobWidget";
  static const String SONAR_QUBE_WIDGET = "SonarQubeWidget";
  static const String BAMBOO_DEPLOYMENT_WIDGET = "BambooDeploymentWidget";
  static const String CHECKBOX_WIDGET = "CheckboxWidget";
  static const String AEM_HEALTHCHECK_WIDGET = "AemHealthcheckWidget";
  static const String SERVICE_CHECK_WIDGET = "ServiceCheckWidget";
  static const String AEM_BUNDLE_INFO_WIDGET = "AemBundleInfoWidget";
  static const String TODO_LIST_WIDGET = "ToDoListWidget";
  static const String LINK_LIST_WIDGET = "LinkListWidget";
  static const String TEXT_WIDGET = "TextWidget";
  static const String WORLD_CLOCK_WIDGET = "WorldClockWidget";
  static const String PERSON_DRAW_WIDGET = "PersonDrawWidget";
}
