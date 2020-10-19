import 'package:flutter/material.dart';

class AemHealthcheckItem extends StatelessWidget {
  final String healthcheckName;
  final String healthcheckValue;
  final String url;

  AemHealthcheckItem({
    @required this.healthcheckName,
    @required this.healthcheckValue,
    @required this.url,
  });

  void openUrl() {
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: [
            Container(
              child: Text(
                "$healthcheckName: $healthcheckValue",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              margin: const EdgeInsets.fromLTRB(26.0, 10.0, 0, 15.0),
            ),
          ],
        ),
        margin: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
      ),
      onTap: openUrl,
    );
  }
}
