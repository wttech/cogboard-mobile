import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetListErrorScreen extends StatelessWidget {
  final String message;

  WidgetListErrorScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        this.message,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
