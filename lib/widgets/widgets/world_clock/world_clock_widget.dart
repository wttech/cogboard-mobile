import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart';

class WorldClockWidget extends StatelessWidget {
  final DashboardWidget widget;

  WorldClockWidget({
    this.widget,
  }) {
    tz.initializeTimeZones();
  }

  bool get getDisplayTime {
    return widget.content['displayTime'];
  }

  bool get getDisplayDate {
    return widget.content['displayDate'];
  }

  String get getTimeFormat {
    return widget.content['timeFormat'];
  }

  String get getDateFormat {
    return widget.content['dateFormat'];
  }

  String get getTimeZoneId {
    return widget.content['timeZoneId'];
  }

  String formatTime(DateTime time) {
    return DateFormat(getTimeFormat).format(time);
  }

  String formatDate(DateTime time) {
    return DateFormat(getDateFormat.replaceAll('dddd', 'EEEE').replaceAll('DD', 'dd').replaceAll('YYYY', 'yyyy'))
        .format(time);
  }

  dynamic getTimeInTimeZone() {
    var zone = getLocation(getTimeZoneId);
    return TZDateTime.now(zone);
  }

  @override
  Widget build(BuildContext context) {
    final clock = Stream<DateTime>.periodic(const Duration(milliseconds: 150), (_) {
      return getTimeInTimeZone();
    });

    return StreamBuilder<DateTime>(
        stream: clock,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (getDisplayTime)
                    Text(
                      formatTime(snapshot.data),
                      style: TextStyle(
                        fontSize: 54,
                      ),
                    ),
                  if (getDisplayDate)
                    Text(
                      formatDate(snapshot.data),
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    )
                ],
              ),
            );
          } else {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
