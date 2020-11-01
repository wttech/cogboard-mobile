import 'dart:math';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:flutter/material.dart';

class ZabbixWidget extends StatefulWidget {
  final DashboardWidget widget;

  ZabbixWidget({
    @required this.widget,
  });

  @override
  _ZabbixWidgetState createState() => _ZabbixWidgetState();
}

class _ZabbixWidgetState extends State<ZabbixWidget> with SingleTickerProviderStateMixin {
  int previousValue;
  AnimationController _controller;
  Tween<double> valueTween;

  @override
  void initState() {
    super.initState();
    previousValue = int.parse(widget.widget.content['lastvalue']);
    this.valueTween = Tween(
      begin: calculatePercentageValue(int.parse(getLastValue)) / 100,
      end: calculatePercentageValue(int.parse(getLastValue)) / 100,
    );
    this._controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    this._controller.forward();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ZabbixWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (previousValue != int.parse(getLastValue)) {
      double begin = this.valueTween?.evaluate(this._controller) ?? calculatePercentageValue(previousValue) ?? 0;
      this.valueTween = Tween<double>(
        begin: begin,
        end: calculatePercentageValue(int.parse(getLastValue)) / 100,
      );
      this._controller
        ..value = 0
        ..forward();
    }
  }

  String get getTitle {
    return ZabbixMetrics[widget.widget.selectedZabbixMetric];
  }

  int get getMaxValue {
    return widget.widget.maxValue;
  }

  String get getProgressType {
    return checkMetricHasProgress() && (!checkMetricHasMaxValue() || widget.widget.maxValue > 0)
        ? 'progress'
        : 'maxValue';
  }

  String get getLastValue {
    return widget.widget.content['lastvalue'];
  }

  bool checkMetricHasMaxValue() {
    return ZabbixMetricsWithMaxValue.contains(widget.widget.selectedZabbixMetric);
  }

  bool checkMetricHasProgress() {
    return ZabbixMetricsWithProgress.contains(widget.widget.selectedZabbixMetric);
  }

  int convertToBytes(int value) {
    return ((100 * value) / (widget.widget.maxValue * pow(10, 9))).round();
  }

  int calculatePercentageValue(int value) {
    if (!checkMetricHasMaxValue()) return value;
    return convertToBytes(value);
  }

  int convertToGigabytes() {
    if (getLastValue == null) return 0;
    return (int.parse(getLastValue) / pow(10, 9)).round();
  }

  String secondsToTime(int value) {
    var days = (value / 3600 / 24).floor().toString();
    var hours = ((value / 3600) % 24).floor().toString();
    var minutes = ((value % 3600) / 60).floor().toString();
    return '${days}d:${hours}h:${minutes}m';
  }

  String get getNoProgressContent {
    return widget.widget.selectedZabbixMetric == 'system.uptime'
        ? secondsToTime(int.parse(getLastValue))
        : int.parse(getLastValue).toString();
  }

  void updatePrevious() {
    print('${previousValue.toString()} -> ${widget.widget.content['lastvalue'].toString()}');
    setState(() {
      previousValue = int.parse(widget.widget.content['lastvalue']);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (previousValue != int.parse(getLastValue)) updatePrevious();
    return getProgressType == 'progress'
        ? Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    Container(
                      child: SizedBox(
                        height: 250.0,
                        width: 250.0,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: CircularProgressIndicator(
                            value: .5,
                            strokeWidth: 25.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                    AnimatedBuilder(
                      animation: this._controller,
                      builder: (BuildContext context, Widget child) {
                        return Container(
                          child: SizedBox(
                            height: 250.0,
                            width: 250.0,
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: CircularProgressIndicator(
                                value: this.valueTween.evaluate(this._controller) * 0.5,
                                strokeWidth: 25.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                          alignment: Alignment.bottomCenter,
                        );
                      },
                      child: Container(),
                    ),
                    Container(
                      child: Text(
                        convertToGigabytes() != 0
                            ? '${convertToGigabytes()}GB/${calculatePercentageValue(int.parse(getLastValue))}%'
                            : '${calculatePercentageValue(int.parse(getLastValue))}%',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.fromLTRB(0, 100.0, 0, 0),
                    ),
                    Container(
                      child: Text(
                        getTitle,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.fromLTRB(0, 150.0, 0, 0),
                    ),
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        : Column(
            children: [
              Container(
                child: Text(
                  getNoProgressContent,
                  style: TextStyle(
                    fontSize: 32,
                  ),
                ),
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 30.0),
              ),
              Container(
                child: Text(
                  getTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          );
  }
}
