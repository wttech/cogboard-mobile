import 'package:cogboardmobileapp/models/jira_bucket_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/jira_buckets/jira_bucket_item.dart';
import 'package:flutter/material.dart';

class JiraBucketWidget extends StatelessWidget {
  final DashboardWidget widget;

  JiraBucketWidget({
    @required this.widget,
  });

  List get getBuckets {
    return (widget.content['buckets'] as List)
        .map((bucket) => JiraBucketModel(
              name: bucket['name'],
              issueCounts: bucket['issueCounts'],
              url: bucket['url'],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return getBuckets.length > 0
        ? DetailsContainer(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        'Bucket',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      margin: const EdgeInsets.fromLTRB(30.0, 20.0, 0, 10.0),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Issues',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      margin: const EdgeInsets.fromLTRB(30.0, 20.0, 0, 10.0),
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
              ...getBuckets
                  .map((bucket) => JiraBucketItem(
                        bucket: bucket,
                      ))
                  .toList(),
            ],
          )
        : Container(
            child: Column(
              children: [
                Text(
                  'No buckets available',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            margin: const EdgeInsets.fromLTRB(0, 40.0, 0, 0),
          );
  }
}
