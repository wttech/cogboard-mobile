import 'dart:math';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/models/zabbix_history_item.dart';
import 'package:cogboardmobileapp/models/zabbix_chart_item_model.dart';
import 'package:cogboardmobileapp/widgets/widgets/zabbix/zabbix_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  List get getHistory {
    Map historyMap = widget.widget.content['history'];
    return historyMap.entries
        .map((e) => ZabbixHistoryItem(
              timestamp: e.key,
              value: e.value,
            ))
        .toList();
  }

  bool get displayUpArrow {
    List historyData = getHistory;
    int current = int.parse(historyData[historyData.length - 1].value);
    int prev = int.parse(historyData[historyData.length - 2].value);
    return current > prev;
  }

  String get getTitle {
    return ZabbixMetrics[widget.widget.selectedZabbixMetric];
  }

  int get getMaxValue {
    return widget.widget.maxValue;
  }

  int get rangeLowerBound {
    return widget.widget.range[0];
  }

  int get rangeUpperBound {
    return widget.widget.range[1];
  }

  String get getProgressType {
    return checkMetricHasProgress() && (!checkMetricHasMaxValue() || widget.widget.maxValue > 0)
        ? 'progress'
        : 'maxValue';
  }

  bool get isSystemUptime {
    return widget.widget.content['name'] == "System uptime";
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

  String get xAxisUnit {
    if (checkMetricHasMaxValue()) {
      return '[GB]';
    } else if (!checkMetricHasProgress()) {
      return 'No.';
    }
    return '[%]';
  }

  charts.Color getColorWhenRangeApplicable(int value) {
    var val = calculatePercentageValue(value);
    if (val < rangeLowerBound)
      return charts.Color.fromHex(
        code: '#019430',
      );
    else if (val >= rangeLowerBound && val < rangeUpperBound)
      return charts.Color.fromHex(
        code: '#ff9924',
      );
    else
      return charts.Color.fromHex(
        code: '#e1322f',
      );
  }

  charts.Color getColorForValue(int value) {
    return checkMetricHasProgress() || convertToGigabytes() != 0
        ? getColorWhenRangeApplicable(value)
        : charts.MaterialPalette.white;
  }

  List<charts.Series<ZabbixChartItemModel, String>> get getChartData {
    List<ZabbixHistoryItem> historyData = getHistory.reversed.toList();
    String firstDate = DateFormat('yMd').format(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(historyData.take(1).map((item) => item.timestamp).first) * 1000));
    var format = historyData
            .take(6)
            .map((item) =>
                DateFormat('yMd').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(item.timestamp) * 1000)))
            .every((date) => date == firstDate)
        ? DateFormat('HH:mm:ss')
        : DateFormat('d.M HH:mm:ss');
    List chartData = historyData
        .take(6)
        .map((item) => ZabbixChartItemModel(
              date: format.format(DateTime.fromMicrosecondsSinceEpoch(int.parse(item.timestamp) * 1000)),
              value: convertToGigabytes() != 0 ? (int.parse(item.value) / pow(10, 9)).round() : int.parse(item.value),
              color: getColorForValue(int.parse(item.value)),
            ))
        .toList();
    return [
      charts.Series<ZabbixChartItemModel, String>(
        id: 'Zabbix',
        domainFn: (ZabbixChartItemModel model, _) => model.date,
        measureFn: (ZabbixChartItemModel model, _) => model.value,
        colorFn: (ZabbixChartItemModel model, _) => model.color,
        data: chartData,
      ),
      charts.Series<ZabbixChartItemModel, String>(
        id: 'Zabbix',
        domainFn: (ZabbixChartItemModel model, _) => model.date,
        measureFn: (ZabbixChartItemModel model, _) => model.value,
        colorFn: (ZabbixChartItemModel model, _) => charts.MaterialPalette.transparent,
        data: chartData,
      )
    ];
  }

  void updatePrevious() {
    setState(() {
      previousValue = int.parse(widget.widget.content['lastvalue']);
    });
  }

  final Widget arrowUp = Icon(
    Icons.arrow_upward,
    size: 28,
    color: Colors.green,
  );

  final Widget arrowDown = Icon(
    Icons.arrow_downward,
    size: 28,
    color: Colors.red,
  );

  Widget noProgressContent() {
    return Container(
      child: Text(
        getNoProgressContent,
        style: TextStyle(
          fontSize: 32,
        ),
      ),
    );
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
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 205, 10, 0),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Container(
                          child: ZabbixChart(
                            seriesList: getChartData,
                            xAxisUnit: xAxisUnit,
                          ),
                        ),
                      ),
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
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      isSystemUptime
                          ? noProgressContent()
                          : Container(
                              margin: const EdgeInsets.fromLTRB(0, 60.0, 0, 30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  noProgressContent(),
                                  displayUpArrow ? arrowUp : arrowDown,
                                ],
                              ),
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
                  ),
                ),
              ),
              if (!isSystemUptime)
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 10, 10),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Container(
                      child: ZabbixChart(
                        seriesList: getChartData,
                        xAxisUnit: xAxisUnit,
                      ),
                    ),
                  ),
                ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          );
  }
}
