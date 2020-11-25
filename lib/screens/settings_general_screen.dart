import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/widgets/settings_sort_by_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsGeneralScreen extends StatefulWidget {
  static const routeName = '/settings/general';
  const SettingsGeneralScreen({Key key}) : super(key: key);

  @override
  _SettingsGeneralScreenState createState() => _SettingsGeneralScreenState();
}

class _SettingsGeneralScreenState extends State<SettingsGeneralScreen> {
  final urlController = TextEditingController();
  final nameController = TextEditingController();
  bool isUrlValid = true;

  @override
  void dispose() {
    urlController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    urlController.text = settingsProvider.notificationsFrequency.toString();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).getTranslation('settingsGeneralScreen.title'),
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () => onSortByClicked(context),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      AppLocalizations.of(context).getTranslation('settingsGeneralScreen.widgetSorting'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  height: 70,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    AppLocalizations.of(context).getTranslation('settingsGeneralScreen.notifications'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: settingsProvider.showHints,
                    onChanged: (value) => settingsProvider.setShowHints(value),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    AppLocalizations.of(context).getTranslation('settingsGeneralScreen.notificationFrequency'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                height: 70,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(AppLocalizations.of(context).getTranslation('settingsGeneralScreen.hints'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
                height: 70,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: settingsProvider.showNotifications,
                    onChanged: (value) => settingsProvider.setShowNotifications(value),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onSortByClicked(BuildContext context) {
    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Container(
          height: 300,
          child: SettingsSortBy(),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context).getTranslation('settingsGeneralScreen.alert.confirm'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}