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

const double WIDGET_ICON_SIZE = 30.0;

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
  static const String JIRA_BUCKETS_WIDGET = "JiraBucketsWidget";
  static const String ZABBIX_WIDGET = "ZabbixWidget";
  static const String IFRAME_EMBED_WIDGET = "IframeEmbedWidget";
  static const String RANDOM_PICKER_WIDGET = "RandomPickerWidget";
}

class WidgetSortTypes {
  static const String NONE = "NONE";
  static const String NAME_DESCENDING = "NAME_DESCENDING";
  static const String NAME_ASCENDING = "NAME_ASCENDING";
  static const String STATUS_DESCENDING = "STATUS_DESCENDING";
  static const String STATUS_ASCENDING = "STATUS_ASCENDING";
}

class WidgetSortByKeys {
  static const String NONE = 'NONE';
  static const String NAME = 'NAME';
  static const String STATUS = 'STATUS';
}

class WidgetSortByOrder {
  static const String ASC = '_ASCENDING';
  static const String DESC = '_DESCENDING';
}

class Hints {
  static const String REFRESH_FETCHING_CONFIG = "REFRESH_FETCHING_CONFIG";
  static const String SWIPE_BOARDS = "SWIPE_BOARDS";
  static const String SWIPE_WIDGET_DETAILS = "SWIPE_WIDGET_DETAILS";
  static const String SWIPE_TO_DELETE = "SWIPE_TO_DELETE";
}

class BoardTypes {
  static const String WIDGET_BOARD = 'WidgetBoard';
  static const String IFRAME_BOARD = 'IframeBoard';
}

const STANDARD_BORDER_RADIOUS = 10.0;

const ZabbixMetrics = {
  'system.users.num': 'Active users',
  'vm.memory.size[available]': 'Available memory',
  'system.cpu.util[,idle]': 'CPU utilization',
  'jmx[\\"java.lang:type=Memory\\",\\"HeapMemoryUsage.used\\"]': 'Mem heap size',
  'proc.num[]': 'Number of processes',
  'system.uptime': 'System uptime',
  'vfs.fs.size[/,used]': 'Used disk space',
  'system.swap.size[,used]': 'Used swap space'
};

const ZabbixMetricsWithProgress = [
  'system.cpu.util[,idle]',
  'vm.memory.size[available]',
  'system.swap.size[,used]',
  'jmx[\\"java.lang:type=Memory\\",\\"HeapMemoryUsage.used\\"]',
  'vfs.fs.size[/,used]'
];

const ZabbixMetricsWithMaxValue = [
  'vm.memory.size[available]',
  'system.swap.size[,used]',
  'jmx[\\"java.lang:type=Memory\\",\\"HeapMemoryUsage.used\\"]',
  'vfs.fs.size[/,used]'
];

const AEM_HEALTH_CHECKS = {
  'inactiveBundles': 'Active Bundles',
  'asyncIndexHealthCheck': 'Async Index Health Check',
  'codeCacheHealthCheck': 'Code Cache Health Check',
  'DiskSpaceHealthCheck': 'Disk Space',
  'logErrorHealthCheck': 'Log Errors',
  'ObservationQueueLengthHealthCheck': 'Observation Queue Length',
  'resourceSearchPathErrorHealthCheck': 'Resource Search Path Errors',
  'requestsStatus': 'Request Performance',
  'queriesStatus': 'Query Performance',
  'queryTraversalLimitsBundle': 'Query Traversal Limits',
  'securitychecks': 'Security Checks',
  'slingJobs': 'Sling Jobs',
  'slingDiscoveryOakSynchronizedClocks': 'Synchronized Clocks',
  'systemchecks': 'System Maintenance',
};

const double FILTER_ICON_SIZE = 22;
