import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/url_preferences_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddConnectionScreen extends StatefulWidget {
  static const routeName = '/add-connection';

  final bool editMode;
  final ConnectionPreferences connection;

  const AddConnectionScreen({Key key, @required this.editMode, this.connection}) : super(key: key);

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

    if (widget.editMode) {
      urlController.text = widget.connection.connectionUrl;
      nameController.text = widget.connection.connectionName;
    }
    return Scaffold(
      appBar: AppBar(
        title: widget.editMode
            ? Text(
                AppLocalizations.of(context).getTranslation('addConnectionScreen.title.edit'),
              )
            : Text(
                AppLocalizations.of(context).getTranslation('addConnectionScreen.title'),
              ),
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
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).getTranslation('addConnectionScreen.name'),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).getTranslation('addConnectionScreen.name.emptyError');
                        }
                        if(widget.editMode) {
                          if(value == widget.connection.connectionName) {
                            return null;
                          }
                        }
                        if (settingsProvider.connections
                            .where((element) => element.connectionName == value)
                            .isNotEmpty) {
                          return AppLocalizations.of(context).getTranslation('addConnectionScreen.name.duplicateError');
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).getTranslation('addConnectionScreen.url'),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      controller: urlController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return AppLocalizations.of(context).getTranslation('addConnectionScreen.url.emptyError');
                        }
                        if (widget.editMode) {
                          if(value == widget.connection.connectionName) {
                            return null;
                          }
                          if (settingsProvider.connections
                              .where((element) =>
                                  element.connectionUrl == value &&
                                  element.connectionName != widget.connection.connectionName)
                              .isNotEmpty) {
                            return AppLocalizations.of(context)
                                .getTranslation('addConnectionScreen.url.duplicateError');
                          }
                        } else {
                          if (settingsProvider.connections
                              .where((element) => element.connectionUrl == value)
                              .isNotEmpty) {
                            return AppLocalizations.of(context)
                                .getTranslation('addConnectionScreen.url.duplicateError');
                          }
                        }
                        if (!isUrlValid) {
                          return AppLocalizations.of(context).getTranslation('addConnectionScreen.url.validationError');
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
                    onPressed: () =>
                        widget.editMode ? onSaveConnectionPressed(context) : onAddConnectionPressed(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.editMode
                            ? AppLocalizations.of(context).getTranslation('addConnectionScreen.save')
                            : AppLocalizations.of(context).getTranslation('addConnectionScreen.addConnection'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
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
      final response =
          await http.get('http://${urlController.text}/api/config').timeout(Duration(seconds: 1), onTimeout: () {
        isUrlValid = false;
        return;
      });
      if (response.statusCode != 200) {
        isUrlValid = false;
        return;
      } else {
        Map<String, dynamic> data = json.decode(response.body) as Map<String, dynamic>;
        if (!data.containsKey('boards') || !data.containsKey('widgets')) {
          isUrlValid = false;
        }
        return;
      }
    } catch (e) {
      isUrlValid = false;
      return;
    }
  }

  Future<void> onSaveConnectionPressed(BuildContext context) async {
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

    if(urlController.text != widget.connection.connectionUrl || nameController.text != widget.connection.connectionName) {
      final settingsProvider = Provider.of<SettingsProvider>(
        context,
        listen: false,
      );
      int connectionIdx = settingsProvider.connections.indexOf(widget.connection);
      ConnectionPreferences connection = new ConnectionPreferences(
        connectionUrl: urlController.text,
        connectionName: nameController.text,
        quarantineWidgets: widget.connection.quarantineWidgets,
        favouriteWidgets: widget.connection.favouriteWidgets,
      );
      await settingsProvider.replaceConnection(connection, connectionIdx);
    }
    Navigator.of(context).pop();
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
