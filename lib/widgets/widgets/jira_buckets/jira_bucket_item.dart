import 'package:cogboardmobileapp/models/jira_bucket_model.dart';
import 'package:cogboardmobileapp/utils/url_launcher.dart';
import 'package:flutter/material.dart';

class JiraBucketItem extends StatelessWidget with UrlLauncher {
  final JiraBucketModel bucket;

  JiraBucketItem({
    this.bucket,
  });

  void handleBucketPressed(BuildContext context) {
    launchUrl(bucket.url, context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  child: Text(
                    bucket.name,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  margin: const EdgeInsets.fromLTRB(30.0, 10.0, 0, 10.0),
                ),
                onTap: () => handleBucketPressed(context),
              ),
            ),
            Expanded(
              child: Container(
                child: Text(
                  bucket.issueCounts.toString(),
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                margin: const EdgeInsets.fromLTRB(30.0, 10.0, 0, 10.0),
              ),
            ),
          ],
        ),
        Container(
          child: Divider(
            color: Colors.grey,
          ),
          margin: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
        ),
      ],
    );
  }
}
