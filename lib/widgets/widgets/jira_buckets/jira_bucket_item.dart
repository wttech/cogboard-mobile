import 'package:cogboardmobileapp/models/jira_bucket_model.dart';
import 'package:flutter/material.dart';

class JiraBucketItem extends StatelessWidget {
  final JiraBucketModel bucket;

  JiraBucketItem({
    this.bucket,
  });

  void handleBucketPressed() {}

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
                onTap: handleBucketPressed,
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
