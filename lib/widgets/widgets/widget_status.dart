import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/providers/widget_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WidgetStatusHeader extends StatelessWidget {
  final String widgetTitle;
  final String status;
  final int lastUpdated;

  WidgetStatusHeader({
    @required this.widgetTitle,
    this.status,
    this.lastUpdated,
  });

  String convertTimestamp(BuildContext context) {
    if (lastUpdated == 0) return AppLocalizations.of(context).getTranslation('widget.notUpdated');
    var date = DateTime.fromMicrosecondsSinceEpoch(lastUpdated * 1000).toLocal();
    return DateFormat('d.M.y H:mm:ss').format(date);
  }

  Icon getStatusIcon() {
    return StatusIcons[status] != null ? StatusIcons[status] : null;
  }

  String getWidgetStatus() {
    return StatusCodes[status] != null ? StatusCodes[status] : '';
  }

  @override
  Widget build(BuildContext context) {
    final widgetProvider = Provider.of<WidgetProvider>(context);

    return Container(
      child: Column(
        children: [
          getWidgetStatus() != ''
              ? Container(
                  child: Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            if (getStatusIcon() != null) getStatusIcon(),
                            Container(
                              child: Text(
                                getWidgetStatus(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              margin: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                            ),
                          ],
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
                )
              : Container(
                  child: null,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40.0),
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
                  margin: getWidgetStatus() != ''
                      ? const EdgeInsets.fromLTRB(30.0, 0, 0, 5.0)
                      : const EdgeInsets.fromLTRB(30.0, 20.0, 0, 5.0),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                if (convertTimestamp(context) != null)
                  Container(
                    child: Text(
                      convertTimestamp(context),
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
      color: StatusColors[widgetProvider.widgetStatus ?? status],
    );
  }
}
