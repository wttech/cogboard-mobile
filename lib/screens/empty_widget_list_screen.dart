import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/material.dart';

class EmptyWidgetListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).getTranslation('emptyWidgetList.body'),
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
