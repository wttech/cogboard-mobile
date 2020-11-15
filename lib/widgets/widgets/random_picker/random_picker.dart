import 'dart:convert' show jsonEncode;
import 'package:cogboardmobileapp/models/random_picker_payload.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomPicker extends StatelessWidget {
  final DashboardWidget widget;

  RandomPicker({
    @required this.widget,
  });

  String get getCurrentName {
    List<String> names = widget.content['multiTextInput'].cast<String>();
    return names[widget.content['index']];
  }

  Future<void> updateName() async {
    const url = 'http://150.254.30.119/api/widget/contentUpdate';
    RandomPickerPayload payload = RandomPickerPayload(
      id: widget.id,
    );
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 50.0, 0, 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            getCurrentName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.cyan,
            ),
            iconSize: 50,
            onPressed: updateName,
          )
        ],
      ),
    );
  }
}
