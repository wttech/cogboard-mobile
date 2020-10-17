import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WidgetStatusHeader extends StatelessWidget {
  final String widgetTitle;
  final String status;
  final int lastUpdated;

  WidgetStatusHeader({
    @required this.widgetTitle,
    this.status,
    this.lastUpdated,
  });

  String convertTimestamp() {
    var date = DateTime.fromMicrosecondsSinceEpoch(lastUpdated * 1000).toLocal();
    return DateFormat("d.M.y H:m:s").format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: const EdgeInsets.fromLTRB(30.0, 20.0, 20.0, 10.0),
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                )
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    widgetTitle,
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                    ),
                  ),
                  margin: const EdgeInsets.fromLTRB(30.0, 0, 0, 5.0),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                Container(
                  child: Text(
                    convertTimestamp(),
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                    ),
                  ),
                  margin: const EdgeInsets.fromLTRB(30.0, 0, 0, 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
      color: Colors.green,
    );
  }
}
