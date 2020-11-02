import 'package:cogboardmobileapp/models/link_list_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/link_list/link_list_item.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final DashboardWidget widget;

  TextWidget({
    @required this.widget,
  });

  String get getText {
    return widget.content["text"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(35.0, 25.0, 35.0, 25.0),
            child: SingleChildScrollView(
              child: Text(
                getText,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          )
        ),
      ],
    );
  }
}
