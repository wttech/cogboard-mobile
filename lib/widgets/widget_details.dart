import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/aem_bundle_info_widget.dart';
import 'package:cogboardmobileapp/widgets/aem_healthcheck_widget.dart';
import 'package:cogboardmobileapp/widgets/bamboo_deployment_widget.dart';
import 'package:cogboardmobileapp/widgets/bamboo_plan_widget.dart';
import 'package:cogboardmobileapp/widgets/checkbox_widget.dart';
import 'package:cogboardmobileapp/widgets/jenkins_job_widget.dart';
import 'package:cogboardmobileapp/widgets/sonar_qube_widget.dart';
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
        break;
      case WidgetTypes.BAMBOO_DEPLOYMENT_WIDGET:
        return BambooDeploymentWidget(widget: widget);
        break;
      case WidgetTypes.JENKINS_JOB_WIDGET:
        return JenkinsJobWidget(widget: widget);
        break;
      case WidgetTypes.SONAR_QUBE_WIDGET:
        return SonarQubeWidget(widget: widget);
        break;
      case WidgetTypes.CHECKBOX_WIDGET:
        return CheckboxWidget(widget: widget);
      case WidgetTypes.AEM_HEALTHCHECK_WIDGET:
        return AemHealthcheckWidget(widget: widget);
      case WidgetTypes.AEM_BUNDLE_INFO_WIDGET:
        return AemBundleInfoWidget(widget: widget);
      default:
        return null;
        break;
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
        return true;
        break;
      case WidgetTypes.CHECKBOX_WIDGET:
        return false;
        break;
      default:
        return false;
        break;
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
                    if (getWidgetDetails(widget) != null)
                      getWidgetDetails(widget),
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
