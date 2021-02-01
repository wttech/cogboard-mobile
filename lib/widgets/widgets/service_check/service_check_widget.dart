import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';

class ServiceCheckWidget extends StatelessWidget {
  final DashboardWidget widget;

  ServiceCheckWidget({
    @required this.widget,
  });

  dynamic get expectedStatusCode => widget.content['expectedStatusCode'];

  dynamic get statusCode => widget.content['statusCode'];

  String get expectedResponseBody => widget.content['expectedResponseBody'];

  String get body => widget.content['body'];

  String get statusMessage => widget.content['statusMessage'];

  bool get errorStatus => expectedStatusCode != statusCode;

  String get bodyMessage => expectedResponseBody == "" || expectedResponseBody == null
      ? 'OK'
      : body.contains(expectedResponseBody)
          ? 'MATCH'
          : 'NO MATCH';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (errorStatus)
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
              child: Text(
                statusMessage,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          Text(
            '${AppLocalizations.of(context).getTranslation('serviceCheck.response')}: $bodyMessage',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
