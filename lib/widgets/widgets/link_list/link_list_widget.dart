import 'package:cogboardmobileapp/models/link_list_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_header.dart';
import 'package:cogboardmobileapp/widgets/widgets/link_list/link_list_item.dart';
import 'package:flutter/material.dart';

class LinkListWidget extends StatelessWidget {
  final DashboardWidget widget;

  LinkListWidget({
    @required this.widget,
  });

  List <LinkListModel> get getLinkListItems {
    return widget.content["linkListItems"].map<LinkListModel>((item) => LinkListModel(
      name: item["linkTitle"],
      url: item["linkUrl"],
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
      child: DetailsContainer(
        children: [
          ...getLinkListItems
            .map((item) => LinkListItem(
              name: item.name,
              url: item.url,))
            .toList()
        ],
      ),
    );
  }
}
