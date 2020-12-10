import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';

class ZabbixChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final String xAxisUnit;

  ZabbixChart({
    this.seriesList,
    this.xAxisUnit,
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
      behaviors: [
        charts.ChartTitle(
          xAxisUnit,
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleStyleSpec: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.Color.fromHex(
              code: '#dddddd',
            ),
          ),
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        ),
        charts.ChartTitle(
          AppLocalizations.of(context).getTranslation('zabbix.date'),
          behaviorPosition: charts.BehaviorPosition.start,
          titleStyleSpec: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.Color.fromHex(
              code: '#dddddd',
            ),
          ),
          titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
        )
      ],
    );
  }
}
