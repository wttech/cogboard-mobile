import 'dart:convert';

import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/translations/app_localizations_delegate.dart';
import 'package:cogboardmobileapp/widgets/widgets/zabbix/zabbix_chart.dart';
import 'package:cogboardmobileapp/widgets/widgets/zabbix/zabbix_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('zabbix widget test', (WidgetTester tester) async {
    // given when
    await tester.pumpWidget(MaterialApp(
      title: 'Title',
      home: ZabbixWidget(
        widget: DashboardWidget.fromJson(jsonDecode(getWidgetJson())),
      ),
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
    ));

    // then
    expect(find.byType(ZabbixChart), findsOneWidget);
  });
}

String getWidgetJson() {
  return "{\r\n  \"id\": \"widget62\",\r\n  \"title\": \"Prod\",\r\n  \"config\": {\r\n    \"columns\": 2,"
      "\r\n    \"goNewLine\": false,\r\n    \"rows\": 1\r\n  },\r\n  \"type\": \"ZabbixWidget\",\r\n  \"disabled\":"
      " false,\r\n  \"content\": {\r\n    \"lastvalue\": \"40516776035\",\r\n    \"isExpandedContent\": true,"
      "\r\n    \"name\": \"Available memory\",\r\n    \"history\": {\r\n      \"1609688069063\": \"46457887619\","
      "\r\n      \"1609688099065\": \"80520258847\",\r\n      \"1609688129063\": \"72700906185\"\r\n    },"
      "\r\n    \"widgetStatus\": \"OK\",\r\n    \"lastUpdated\": 1609691639085\r\n  },\r\n  \"isUpdating\": false,"
      "\r\n  \"boardId\": \"board-acdc6ecc-2bcd-4f8f-80a3-5db8a5db8394\",\r\n  \"endpoint\": \"endpoint3\","
      "\r\n  \"schedulePeriod\": 30,\r\n  \"host\": \"\",\r\n  \"selectedZabbixMetric\": \"vm.memory.size[available]\","
      "\r\n  \"maxValue\": 100,\r\n  \"range\": [\r\n    60,\r\n    80\r\n  ]\r\n}";
}
