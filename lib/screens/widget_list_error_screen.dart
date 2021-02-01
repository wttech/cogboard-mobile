import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetListErrorScreen extends StatelessWidget {
  final String message;
  final Function refresh;

  WidgetListErrorScreen({this.message, this.refresh});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          this.message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        FlatButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: refresh,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(STANDARD_BORDER_RADIOUS),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              AppLocalizations.of(context).getTranslation('widgetListErrorScreen.retry'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
