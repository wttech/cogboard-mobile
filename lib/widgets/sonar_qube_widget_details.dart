import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/details_header.dart';
import 'package:cogboardmobileapp/widgets/widget_details_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SonarQubeWidgetDetails extends StatelessWidget {
  final DashboardWidget widget;

  SonarQubeWidgetDetails({
    @required this.widget,
  });

  String get getTimestamp {
    if (widget.content["date"] != null) {
      var date = DateTime.parse(widget.content["date"]).toLocal();
      return DateFormat("y.MM.dd, H:mm:ss").format(date);
    }
    return null;
  }

  String get getVersion {
    return widget.content["version"] != null && widget.content["version"] != "-"
        ? "Version: ${widget.content["version"]}"
        : null;
  }

  List get getMetrics {
    Map metrics = widget.content["metrics"];
    return metrics.entries
        .map((metric) => WidgetDetailsItem(
            detail:
                "${metric.key.toString().replaceFirst("_", " ")}: ${metric.value}"))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      children: [
        DetailsHeader(header: "Details"),
        if (getTimestamp != null) WidgetDetailsItem(detail: getTimestamp),
        if (getVersion != null) WidgetDetailsItem(detail: getVersion),
        ...getMetrics,
      ],
    );
  }
}
