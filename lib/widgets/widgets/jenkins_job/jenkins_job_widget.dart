import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_header.dart';
import 'package:cogboardmobileapp/widgets/widgets/widget_details_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JenkinsJobWidget extends StatelessWidget {
  final DashboardWidget widget;

  JenkinsJobWidget({
    @required this.widget,
  });

  bool get isInProgress {
    return widget.content['widgetStatus'] == WidgetStatusCodes.IN_PROGRESS;
  }

  String get getTimestamp {
    if (widget.content["timestamp"] != null) {
      var date = DateTime.fromMicrosecondsSinceEpoch(widget.content["timestamp"] * 1000).toLocal();
      return DateFormat("y.M.d, H:mm:ss").format(date);
    }
    return null;
  }

  String get getDuration {
    return widget.content["duration"] != null ? "Duration: ${widget.content["duration"] / 1000} [s]" : null;
  }

  String get getBranch {
    return widget.content["branch"] != null ? widget.content["branch"] : null;
  }

  @override
  Widget build(BuildContext context) {
    return isInProgress
        ? DetailsContainer(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        strokeWidth: 5.0,
                      ),
                      height: 75,
                      width: 75,
                    ),
                  ],
                ),
              ),
            ],
          )
        : DetailsContainer(
            children: [
              DetailsHeader(header: AppLocalizations.of(context).getTranslation('jenkinsJob.details')),
              if (getTimestamp != null) WidgetDetailsItem(detail: getTimestamp),
              if (getDuration != null) WidgetDetailsItem(detail: getDuration),
              if (getBranch != null) WidgetDetailsItem(detail: getBranch),
            ],
          );
  }
}
