import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddConnectionScreen extends StatelessWidget {
  static const routeName = '/add-connection';
  const AddConnectionScreen({Key key}) : super(key: key);

  Future<void> goBack(BuildContext ctx) {
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
    );
  }
}
