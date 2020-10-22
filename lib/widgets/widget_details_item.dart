import 'package:flutter/material.dart';

class WidgetDetailsItem extends StatelessWidget {
  final String detail;

  WidgetDetailsItem({
    @required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            detail,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(30.0, 0, 0, 20.0),
    );
  }
}
