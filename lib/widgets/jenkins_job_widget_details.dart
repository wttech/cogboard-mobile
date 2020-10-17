import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widget_details_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JenkinsJobWidgetDetails extends StatelessWidget {
  final DashboardWidget widget;

  JenkinsJobWidgetDetails({
    @required this.widget,
  });

  String get getTimestamp {
    if (widget.content["timestamp"] != null) {
      var date = DateTime.fromMicrosecondsSinceEpoch(
              widget.content["timestamp"] * 1000)
          .toLocal();
      return DateFormat("y.M.d, H:mm:ss").format(date);
    }
    return null;
  }

  String get getDuration {
    return widget.content["duration"] != null
        ? "Duration: ${widget.content["duration"] / 1000} [s]"
        : null;
  }

  String get getBranch {
    return widget.content["branch"];
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      children: [
        if (getTimestamp != null) WidgetDetailsItem(detail: getTimestamp),
        if (getDuration != null) WidgetDetailsItem(detail: getDuration),
        WidgetDetailsItem(detail: getBranch),
      ],
    );
  }
}
