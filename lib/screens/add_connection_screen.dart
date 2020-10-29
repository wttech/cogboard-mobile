import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/connection_model.dart';
import 'package:cogboardmobileapp/providers/settings_provider.dart';
import 'package:cogboardmobileapp/screens/login_screen.dart';
import 'package:cogboardmobileapp/widgets/basic/input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    urlController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Connection'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Input(
                  labelText: 'Name',
                  controller: nameController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Input(
                  labelText: 'Url',
                  controller: urlController,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Connection c = new Connection(
                    url: urlController.text,
                    name: nameController.text,
                    lastVisited: false,
                  );
                  final settingsProvider = Provider.of<SettingsProvider>(
                    context,
                    listen: false,
                  );

                  settingsProvider.addConnection(c);
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
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
    );
  }
}
