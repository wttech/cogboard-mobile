import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'loginScreen.connect': {
      'en': 'CONNECT',
    },
    'addConnectionScreen.title': {
      'en': 'New Connection',
    },
    'addConnectionScreen.name': {
      'en': 'Name',
    },
    'addConnectionScreen.name.emptyError': {
      'en': 'Please provide a name.',
    },
    'addConnectionScreen.name.duplicateError': {
      'en': 'This connection name is occupied.',
    },
    'addConnectionScreen.url': {
      'en': 'Url',
    },
    'addConnectionScreen.url.emptyError': {
      'en': 'Please provide a url.',
    },
    'addConnectionScreen.url.duplicateError': {
      'en': 'This connection name is occupied.',
    },
    'addConnectionScreen.url.validationError': {
      'en': 'Url is not valid.',
    },
    'addConnectionScreen.addConnection': {
      'en': 'ADD CONNECTION',
    },
    'urlSelect.noConnections': {
      'en': 'There are no Connections saved',
    },
    'dashboardsScreen.boardError.title': {
      'en': 'Board error',
    },
    'dashboardsScreen.boardError.body': {
      'en': 'API connection error occurred!',
    },
    'dashboardsScreen.widgetChangedNotification': {
      'en': 'Some widgets have changed their status:',
    },
    'dashboardsScreen.hintDialogTextRefreshFetchConfig': {
      'en': 'Swipe up to fetch config again',
    },
    'dashboardsScreen.hintDialogTextSwipeBoards': {
      'en': 'Swipe left and right to switch between boards',
    },
    'dashboardsScreen.hintDialogConfirm': {
      'en': 'Ok',
    },
    'emptyWidgetList.body': {
      'en': 'This list is empty.',
    },
    'settingsHints.hints': {
      'en': 'Hints',
    },
    'settingsHints.showHints': {
      'en': 'Show hints',
    },
    'settingsNotifications.notifications': {
      'en': 'Notifications',
    },
    'settingsNotifications.showNotifications': {
      'en': 'Show notifications',
    },
    'settingsNotifications.notificationsFrequencyInput': {
      'en': 'Show notifications',
    },
    'settingsProjectList.projects': {
      'en': 'Projects',
    },
    'settingsScreen.title': {
      'en': 'Settings',
    },
    'settingsSortBy.widgets': {
      'en': 'Widgets',
    },
    'settingsSortBy.sortBy': {
      'en': 'Sort by',
    },
    'settingsSortBy.none': {
      'en': 'NONE',
    },
    'settingsSortBy.name': {
      'en': 'NAME',
    },
    'settingsSortBy.status': {
      'en': 'STATUS',
    },
    'widgetScreen.errorTitle': {
      'en': 'Widget details',
    },
    'widgetScreen.hintDialogText': {
      'en': 'Swipe left and right to switch between widget details',
    },
    'widgetScreen.hintDialogConfirm': {
      'en': 'Ok',
    },
    'widgetScreen.errorBody': {
      'en': 'Websocket connection error occured!',
    },
    'widgetScreen.alertDialog.message': {
      'en': 'Do you want this widget to be removed form quarantine at expiration date',
    },
    'widgetScreen.alertDialog.confirm': {
      'en': 'YES',
    },
    'widgetScreen.alertDialog.decline': {
      'en': 'NO',
    },
    'widgetListScreen.errorTitle': {
      'en': 'Dashboard',
    },
    'widgetListErrorScreen.retry': {
      'en': 'retry connecting again',
    },
    'widgetListScreen.errorBody': {
      'en': 'Websocket connection error occurred!',
    },
    'widgetListScreen.hintDialogText': {
      'en': 'Swipe left to remove widget from list',
    },
    'widgetListScreen.hintDialogConfirm': {
      'en': 'Ok',
    },
    'aemBundleInfo.excludedBundles': {
      'en': 'Excluded bundles',
    },
    'aemBundleInfo.noExcludedBundles': {
      'en': 'No excluded bundles',
    },
    'aemBundleInfo.inactiveBundles': {
      'en': 'Inactive bundles',
    },
    'aemBundleInfo.noInactiveBundles': {
      'en': 'No inactive bundles',
    },
    'aemHealthcheck.healthchecks': {
      'en': 'Healthchecks',
    },
    'bambooDeployment.details': {
      'en': 'Details',
    },
    'bambooDeployment.deploymentState': {
      'en': 'Deployment state: ',
    },
    'bambooDeployment.lifecycleState': {
      'en': 'Lifecycle state: ',
    },
    'bambooPlan.details': {
      'en': 'Details',
    },
    'bambooPlan.state': {
      'en': 'State: ',
    },
    'jenkinsJob.details': {
      'en': 'Details',
    },
    'jiraBuckets.bucket': {
      'en': 'Bucket',
    },
    'jiraBuckets.issues': {
      'en': 'Issues',
    },
    'jiraBuckets.noBuckets': {
      'en': 'No buckets available',
    },
    'sonarQube.details': {
      'en': 'Details',
    },
    'worldClock.loading': {
      'en': 'Loading...',
    },
    'dissmisibleWidgetList.removed': {
      'en': 'Removed ',
    },
    'dissmisibleWidgetList.undo': {
      'en': 'UNDO',
    },
    'serviceCheck.response': {
      'en': 'Response',
    },
    'urlLauncher.toast': {
      'en': 'URL error occurred',
    },
    'iframeEmbed.blankUrl': {
      'en': 'URL is blank',
    },
    'widget.notUpdated': {
      'en': 'Not updated yet',
    },
  };

  String getTranslation(String key) {
    return _localizedValues[key][locale.languageCode];
  }
}
