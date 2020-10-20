import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  const Input({this.labelText, this.controller});

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new TextField(
        controller: controller,
        decoration: new InputDecoration(
          labelText: labelText,
          // hintText: 'Enter connection name',
          enabledBorder: OutlineInputBorder(
            // normal state
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onBackground.withAlpha(150),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
