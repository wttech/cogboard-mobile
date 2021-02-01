import 'package:flutter/material.dart';

class SettingsSortByOption extends StatelessWidget {
  final String name;
  final Function onTap;
  final bool check;

  const SettingsSortByOption({Key key, @required this.name, @required this.onTap, @required this.check})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget checkIcon = Container();
    if (check) {
      checkIcon = Icon(
        Icons.check,
        size: 16,
      );
    }

    return Container(
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: 40,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            checkIcon,
          ],
        ),
      ),
    );
  }
}
