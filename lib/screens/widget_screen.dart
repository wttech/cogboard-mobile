import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:flutter/material.dart';

class DashboardItemScreen extends StatelessWidget {
  static const routeName = '/widget';

  @override
  Widget build(BuildContext context) {
    final DashboardWidget widget =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
