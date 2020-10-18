import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/aem_healthcheck_item.dart';
import 'package:cogboardmobileapp/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/details_header.dart';
import 'package:flutter/material.dart';

class AemHealthcheckWidgetDetails extends StatelessWidget {
  final DashboardWidget widget;

  AemHealthcheckWidgetDetails({
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
