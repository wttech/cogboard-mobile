import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/widgets/configuration_error_details.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_header.dart';
import 'package:cogboardmobileapp/widgets/widgets/widget_details_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SonarQubeWidget extends StatelessWidget {
  final DashboardWidget widget;

  SonarQubeWidget({
    @required this.widget,
  });

  bool get isConfigurationError {
    return widget.content['widgetStatus'] == WidgetStatusCodes.ERROR_CONFIGURATION;
  }

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
              detail: "${toBeginningOfSentenceCase(metric.key.toString().replaceFirst("_", " "))}: ${metric.value}",
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return isConfigurationError
        ? ConfigurationErrorDetails()
        : DetailsContainer(
            children: [
              DetailsHeader(header: AppLocalizations.of(context).getTranslation('sonarQube.details')),
              if (getTimestamp != null) WidgetDetailsItem(detail: getTimestamp),
              if (getVersion != null) WidgetDetailsItem(detail: getVersion),
              ...getMetrics,
            ],
          );
  }
}
