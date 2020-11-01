import 'package:cogboardmobileapp/models/aem_healthcheck_item_model.dart';
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

  List<AemHealthcheckItemModel> get getHealthchecks {
    Map healthchecks = widget.content["healthChecks"];
    return healthchecks.entries
        .map((hc) => AemHealthcheckItemModel(
              name: hc.key,
              value: hc.value["status"],
              url: hc.value["url"],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      children: [
        DetailsHeader(header: "Healthchecks"),
        ...getHealthchecks
            .map((hc) => AemHealthcheckItem(
                  healthcheckName: hc.name,
                  healthcheckValue: hc.value,
                  url: hc.url,
                ))
            .toList(),
      ],
    );
  }
}
