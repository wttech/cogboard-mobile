import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';

class ConfigurationErrorDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
          child: Icon(
            Icons.warning,
            color: Colors.white,
            size: 64.0,
          ),
        ),
        Text(
          AppLocalizations.of(context).getTranslation('widgetStatus.errorConfiguration'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
