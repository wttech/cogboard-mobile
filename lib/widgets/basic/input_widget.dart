import 'package:cogboardmobileapp/constants/constants.dart';
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
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onBackground.withAlpha(150),
            ),
            borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
            borderRadius: BorderRadius.circular(STANDARD_BORDER_RADIOUS),
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
