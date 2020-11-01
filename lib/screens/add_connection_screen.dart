import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddConnectionScreen extends StatefulWidget {
  static const routeName = '/add-connection';

  const AddConnectionScreen({Key key}) : super(key: key);

  @override
  _AddConnectionScreenState createState() => _AddConnectionScreenState();
}

class _AddConnectionScreenState extends State<AddConnectionScreen> {
  final urlController = TextEditingController();
  final nameController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool isUrlValid = true;

  @override
  void dispose() {
    urlController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('New Connection'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Form(
        key: _form,
        child: Container(
          constraints: BoxConstraints.expand(),
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a name.';
                        }
                        if(settingsProvider.connections.where((element) => element.connectionName == value).isNotEmpty) {
                          return 'This connection name is occupied.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Url',
                      ),
                      controller: urlController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a url.';
                        }
                        if(settingsProvider.connections.where((element) => element.connectionUrl == value).isNotEmpty) {
                          return 'This connection name is occupied.';
                        }
                        if(!isUrlValid) {
                          return 'Url is not valid.';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FlatButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () => onAddConnectionPressed(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(standardBorderRadius),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'ADD CONNECTION',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkUrlValidity() async {
    try {
      final response = await http.get('http://${urlController.text}/api/config');
      if (response.statusCode != 200) {
        isUrlValid = false;
        return;
      } else {
        Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        if(!data.containsKey('boards') || !data.containsKey('widgets')) {
          isUrlValid = false;
        }
        return;
      }
    } catch (e) {
      isUrlValid = false;
      return;
    }
  }

  Future<void> onAddConnectionPressed(BuildContext context) async {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    await checkUrlValidity();
    isValid = _form.currentState.validate();
    if (!isValid) {
      isUrlValid = true;
      return;
    }
    ConnectionPreferences connection = new ConnectionPreferences(
      connectionUrl: urlController.text,
      connectionName: nameController.text,
      quarantineWidgets: [],
      favouriteWidgets: [],
    );
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );
    await settingsProvider.addConnection(connection);
    await settingsProvider.setCurrentConnection(connection);
    Navigator.of(context).pop();
  }
}
