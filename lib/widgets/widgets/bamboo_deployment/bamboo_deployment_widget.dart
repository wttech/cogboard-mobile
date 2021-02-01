import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_header.dart';
import 'package:cogboardmobileapp/widgets/widgets/widget_details_item.dart';
import 'package:flutter/material.dart';

class BambooDeploymentWidget extends StatelessWidget {
  final DashboardWidget widget;

  BambooDeploymentWidget({
    @required this.widget,
  });

  String get getDeploymentState {
    return widget.content["deploymentState"];
  }

  String get getLifeCycleState {
    return widget.content["lifeCycleState"];
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      children: [
        DetailsHeader(
          header: AppLocalizations.of(context).getTranslation('bambooDeployment.details'),
        ),
        WidgetDetailsItem(
            detail: AppLocalizations.of(context).getTranslation('bambooDeployment.deploymentState') +
                "$getDeploymentState"),
        WidgetDetailsItem(
            detail:
                AppLocalizations.of(context).getTranslation('bambooDeployment.lifecycleState') + "$getLifeCycleState"),
      ],
    );
  }
}
