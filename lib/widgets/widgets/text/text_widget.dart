import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final DashboardWidget widget;

  TextWidget({
    @required this.widget,
  });

  String get getText {
    return widget.content['text'];
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 25.0, 0, 25.0),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                  child: Text(
                    getText,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
