import 'package:cogboardmobileapp/utils/url_launcher.dart';
import 'package:flutter/material.dart';

class LinkListItem extends StatelessWidget with UrlLauncher {
  final String name;
  final String url;

  LinkListItem({
    @required this.name,
    @required this.url,
  });

  void openUrl(BuildContext context) {
    launchUrl(url, context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: [
            Container(
              child: Text(
                "$name",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              margin: const EdgeInsets.fromLTRB(26.0, 10.0, 0, 15.0),
            ),
          ],
        ),
        margin: const EdgeInsets.fromLTRB(5.0, 10, 0, 0),
      ),
      onTap: () => openUrl(context),
    );
  }
}
