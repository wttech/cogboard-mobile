import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/utils/url_launcher.dart';
import 'package:flutter/material.dart';

class OpenUrlButton extends StatelessWidget with UrlLauncher {
  final DashboardWidget widget;

  OpenUrlButton({
    @required this.widget,
  });

  String get widgetUrl {
    return widget.content['url'];
  }

  dynamic get statusCode => widget.content['statusCode'];

  dynamic get expectedStatusCode => widget.content['expectedStatusCode'];

  bool get errorStatus => expectedStatusCode != statusCode;

  String get statusCodeMessage =>
      errorStatus ? '$expectedStatusCode expected, got $statusCode' : widget.content['statusCode'].toString();

  void openDetailsUrl(BuildContext context) {
    launchUrl(widgetUrl, context);
  }

  String get getUrlDisplayName {
    switch (widget.type) {
      case WidgetTypes.BAMBOO_PLAN_WIDGET:
        return widget.content['number'] != null ? '#${widget.content['number']}' : null;
      case WidgetTypes.BAMBOO_DEPLOYMENT_WIDGET:
        return widget.content['releaseName'] != null ? '${widget.content['releaseName']}' : null;
      case WidgetTypes.JENKINS_JOB_WIDGET:
        return widget.content['displayName'] != null ? '${widget.content['displayName']}' : null;
      case WidgetTypes.SERVICE_CHECK_WIDGET:
        return statusCodeMessage;
      case WidgetTypes.SONAR_QUBE_WIDGET:
        return 'OPEN DASHBOARD';
      case WidgetTypes.AEM_HEALTHCHECK_WIDGET:
        return 'OPEN REPORT';
      case WidgetTypes.AEM_BUNDLE_INFO_WIDGET:
        return 'VIEW BUNDLES';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return getUrlDisplayName != null
        ? Center(
            child: FractionallySizedBox(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  child: OutlineButton(
                    onPressed: () => openDetailsUrl(context),
                    child: Text(
                      getUrlDisplayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1,
                    ),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  height: 50.0,
                ),
              ),
              widthFactor: 1,
            ),
          )
        : Container();
  }
}
