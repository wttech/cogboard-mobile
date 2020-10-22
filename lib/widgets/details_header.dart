import 'package:flutter/material.dart';

class DetailsHeader extends StatelessWidget {
  final String header;

  DetailsHeader({
    @required this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            child: Text(
              header,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            margin: const EdgeInsets.fromLTRB(30.0, 20.0, 0, 21.0),
          ),
        ],
      ),
    );
  }
}
