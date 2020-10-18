import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/details_header.dart';
import 'package:cogboardmobileapp/widgets/widget_details_item.dart';
import 'package:flutter/material.dart';

class BambooPlanWidgetDetails extends StatelessWidget {
  final DashboardWidget widget;

  BambooPlanWidgetDetails({
    @required this.widget,
  });

  String get getLifeCycleState {
    return widget.content["lifeCycleState"];
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      children: [
        DetailsHeader(header: "Details"),
        WidgetDetailsItem(detail: "State: $getLifeCycleState"),
      ],
    );
  }
}
