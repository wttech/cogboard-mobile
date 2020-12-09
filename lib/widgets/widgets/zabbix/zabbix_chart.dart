import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ZabbixChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  ZabbixChart({
    this.seriesList,
  });

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      vertical: false,
      animate: false,
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }
}
