import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/widgets/aem_bundle_info/aem_bundle_info_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/aem_healthcheck/aem_healthcheck_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/bamboo_deployment/bamboo_deployment_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/bamboo_plan/bamboo_plan_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/checkbox/checkbox_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/jenkins_job/jenkins_job_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/jira_buckets/jira_buckets_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/sonar_qube/sonar_qube_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/todo_list/todo_list_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/world_clock/world_clock_widget.dart';
import 'package:cogboardmobileapp/widgets/widgets/zabbix/zabbix_widget.dart';
import 'package:flutter/material.dart';

class WidgetDetails extends StatelessWidget {
  final DashboardWidget widget;

  WidgetDetails({
    @required this.widget,
  });

  Widget getWidgetDetails(DashboardWidget widget) {
    switch (widget.type) {
      case WidgetTypes.BAMBOO_PLAN_WIDGET:
        return BambooPlanWidget(widget: widget);
      case WidgetTypes.BAMBOO_DEPLOYMENT_WIDGET:
        return BambooDeploymentWidget(widget: widget);
      case WidgetTypes.JENKINS_JOB_WIDGET:
        return JenkinsJobWidget(widget: widget);
      case WidgetTypes.SONAR_QUBE_WIDGET:
        return SonarQubeWidget(widget: widget);
      case WidgetTypes.CHECKBOX_WIDGET:
        return CheckboxWidget(widget: widget);
      case WidgetTypes.AEM_HEALTHCHECK_WIDGET:
        return AemHealthcheckWidget(widget: widget);
      case WidgetTypes.AEM_BUNDLE_INFO_WIDGET:
        return AemBundleInfoWidget(widget: widget);
      case WidgetTypes.WORLD_CLOCK_WIDGET:
        return WorldClockWidget(widget: widget);
      case WidgetTypes.JIRA_BUCKETS_WIDGET:
        return JiraBucketWidget(widget: widget);
      case WidgetTypes.ZABBIX_WIDGET:
        return ZabbixWidget(widget: widget);
      case WidgetTypes.TODO_LIST_WIDGET:
        return TodoListWidget(widget: widget);
      default:
        return Container(
          child: null,
        );
    }
  }

  bool widgetContainsDetails(DashboardWidget widget) {
    switch (widget.type) {
      case WidgetTypes.BAMBOO_PLAN_WIDGET:
      case WidgetTypes.BAMBOO_DEPLOYMENT_WIDGET:
      case WidgetTypes.JENKINS_JOB_WIDGET:
      case WidgetTypes.SONAR_QUBE_WIDGET:
      case WidgetTypes.AEM_HEALTHCHECK_WIDGET:
      case WidgetTypes.AEM_BUNDLE_INFO_WIDGET:
      case WidgetTypes.JIRA_BUCKETS_WIDGET:
      case WidgetTypes.TODO_LIST_WIDGET:
        return true;
      case WidgetTypes.CHECKBOX_WIDGET:
      case WidgetTypes.WORLD_CLOCK_WIDGET:
      case WidgetTypes.ZABBIX_WIDGET:
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widgetContainsDetails(widget)
        ? Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    if (getWidgetDetails(widget) != null) getWidgetDetails(widget),
                  ],
                ),
              ],
            ),
          )
        : Expanded(
            child: getWidgetDetails(widget),
          );
  }
}
