import 'package:cogboardmobileapp/providers/settings_provider.dart';
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
        title: Text('General'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => onSortByClicked(context),
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      'Sort Widgets By',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  height: 70,
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
                    'Notifications',
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
                    'Notification Frequency',
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
                  child: Text('Hints',
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
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Sort Widgets By'),
        content: Container(
          height: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Text('Sort By'),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      height: 50,
                      child: Text('None'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      height: 50,
                      child: Text('Name'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    child: Container(
                      height: 50,
                      child: Text('Status'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
