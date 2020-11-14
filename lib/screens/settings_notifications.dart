import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsNotifications extends StatefulWidget {
  @override
  _SettingsNotificationsState createState() => _SettingsNotificationsState();
}

class _SettingsNotificationsState extends State<SettingsNotifications> {
  final notificationFrequencyController = TextEditingController();

  @override
  void dispose() {
    notificationFrequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    notificationFrequencyController.text = settingsProvider.notificationsFrequency.toString();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              AppLocalizations.of(context).getTranslation('settingsNotifications.notifications'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              AppLocalizations.of(context).getTranslation('settingsNotifications.showNotifications'),
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Switch(
                value: settingsProvider.showNotifications,
                onChanged: (value) => settingsProvider.setShowNotifications(value),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 100.0),
                child: TextField(
                  decoration: new InputDecoration(
                    labelText: AppLocalizations.of(context)
                        .getTranslation('settingsNotifications.notificationsFrequencyInput'),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (input) {
                    if (input.isEmpty) {
                      settingsProvider.setNotificationsFrequency(1);
                    }
                    int frequency = int.parse(input);
                    if (frequency > 9999) {
                      settingsProvider.setNotificationsFrequency(9999);
                    } else {
                      settingsProvider.setNotificationsFrequency(frequency);
                    }
                  },
                  controller: notificationFrequencyController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ], // Only numbers can be entered
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
