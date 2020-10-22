import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/checkbox_update_payload.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/providers/widget_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CheckboxWidget extends StatefulWidget {
  final DashboardWidget widget;

  CheckboxWidget({
    @required this.widget,
  });

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  String get getWidgetStatus {
    return widget.widget.content[DashboardWidget.WIDGET_STATUS_KEY];
  }

  String getNextStatus(String status) {
    const statusArray = [
      'CHECKBOX_OK',
      'CHECKBOX_FAIL',
      'CHECKBOX_UNKNOWN',
    ];
    int statusIndex = statusArray.indexWhere((element) => element == status);
    int nextStatusIndex = 0;

    if (statusIndex != -1) {
      nextStatusIndex =
          statusIndex < statusArray.length - 1 ? statusIndex + 1 : 0;
    } else {
      nextStatusIndex =
          statusArray.indexWhere((element) => element == 'CHECKBOX_UNKNOWN');
    }
    return statusArray[nextStatusIndex];
  }

  Future<void> updateCheckbox() async {
    const url = 'http://150.254.30.119/api/widget/contentUpdate';
    CheckboxUpdatePayload payload = CheckboxUpdatePayload(
      id: widget.widget.id,
      widgetStatus: getNextStatus(getWidgetStatus),
    );
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );
  }

  void handleChangeStatus(WidgetProvider widgetProvider) {
    widgetProvider.setWidgetStatus(getNextStatus(getWidgetStatus));
    updateCheckbox();
  }

  @override
  Widget build(BuildContext context) {
    final widgetProvider = Provider.of<WidgetProvider>(context);

    return Column(
      children: [
        Container(
          height: 150,
          width: 150,
          child: SizedBox(
            child: OutlineButton(
              onPressed: () => handleChangeStatus(widgetProvider),
              child: CheckboxIcons[
                  widgetProvider.widgetStatus ?? getWidgetStatus],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              borderSide: BorderSide(
                color: Colors.white,
                width: 5,
              ),
            ),
          ),
        ),
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
