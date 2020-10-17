import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/bamboo_deployment_widget_details.dart';
import 'package:cogboardmobileapp/widgets/bamboo_plan_widget_details.dart';
import 'package:cogboardmobileapp/widgets/checkbox_widget_details.dart';
import 'package:cogboardmobileapp/widgets/jenkins_job_widget_details.dart';
import 'package:cogboardmobileapp/widgets/sonar_qube_widget_details.dart';
import 'package:flutter/material.dart';

class WidgetDetails extends StatelessWidget {
  final DashboardWidget widget;

  WidgetDetails({
    @required this.widget,
  });

  Widget getWidgetDetails(DashboardWidget widget) {
    switch (widget.type) {
      case WidgetTypes.BAMBOO_PLAN_WIDGET:
        return BambooPlanWidgetDetails(
          widget: widget,
        );
        break;
      case WidgetTypes.BAMBOO_DEPLOYMENT_WIDGET:
        return BambooDeploymentWidgetDetails(
          widget: widget,
        );
        break;
      case WidgetTypes.JENKINS_JOB_WIDGET:
        return JenkinsJobWidgetDetails(
          widget: widget,
        );
        break;
      case WidgetTypes.SONAR_QUBE_WIDGET:
        return SonarQubeWidgetDetails(
          widget: widget,
        );
        break;
      case WidgetTypes.CHECKBOX_WIDGET:
        return CheckboxWidgetDetails(
          widget: widget,
        );
      default:
        return null;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Text(
                      "Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    margin: const EdgeInsets.fromLTRB(30.0, 20.0, 0, 21.0),
                  ),
                ],
              ),
              if (getWidgetDetails(widget) != null) getWidgetDetails(widget),
            ],
          ),
        ],
      ),
    );
  }
}
