import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:flutter/material.dart';

class RandomPicker extends StatelessWidget {
  final DashboardWidget widget;

  RandomPicker({
    @required this.widget,
  });

  String get getCurrentName {
    List<String> names = widget.content['multiTextInput'].cast<String>();
    return names[widget.content['index']];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getCurrentName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }
}
