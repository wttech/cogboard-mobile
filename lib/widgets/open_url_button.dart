import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:flutter/material.dart';

class OpenUrlButton extends StatelessWidget {
  final DashboardWidget widget;

  OpenUrlButton(this.widget);

  String get _getWidgetUrl {
    return widget.content["url"];
  }

  String get _getBuildNumber {
    return "#${widget.content["buildNumber"]}";
  }

  void openDetailsUrl() {
    print('url opened');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            child: OutlineButton(
              onPressed: openDetailsUrl,
              child: Text(
                _getBuildNumber,
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
    );
  }
}
