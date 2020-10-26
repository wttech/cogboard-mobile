import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/widgets/aem_healthcheck/aem_healthcheck_item.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_header.dart';
import 'package:flutter/material.dart';

class AemHealthcheckWidget extends StatelessWidget {
  final DashboardWidget widget;

  AemHealthcheckWidget({
    @required this.widget,
  });

  List get getHealthchecks {
    Map healthchecks = widget.content["healthChecks"];
    return healthchecks.entries
        .map((hc) => AemHealthcheckItem(
              healthcheckName: hc.key,
              healthcheckValue: hc.value["status"],
              url: hc.value["url"],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      children: [
        DetailsHeader(header: "Healthchecks"),
        ...getHealthchecks,
      ],
    );
  }
}
