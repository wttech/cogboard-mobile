import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_header.dart';
import 'package:cogboardmobileapp/widgets/widgets/widget_details_item.dart';
import 'package:flutter/material.dart';

class AemBundleInfoWidget extends StatelessWidget {
  final DashboardWidget widget;

  AemBundleInfoWidget({
    @required this.widget,
  });

  List get getBundleStatus {
    Map status = widget.content["bundleStatus"];
    return status.entries
        .map((item) => WidgetDetailsItem(
              detail: "${item.key.toString().toUpperCase()}: ${item.value}",
            ))
        .toList();
  }

  List get getExcludedBundles {
    List bundles = widget.content["excludedBundles"];
    return bundles
        .map((bundle) => WidgetDetailsItem(
              detail: "$bundle",
            ))
        .toList();
  }

  List get getInactiveBundles {
    List bundles = widget.content["inactiveBundles"];
    return bundles
        .map((bundle) => WidgetDetailsItem(
              detail: "$bundle",
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      children: [
        Container(
          child: Column(
            children: [
              ...getBundleStatus,
            ],
          ),
          margin: const EdgeInsets.fromLTRB(0, 30.0, 0, 0),
        ),
        Container(
          child: Divider(
            color: Colors.grey,
          ),
          margin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
        ),
        getExcludedBundles.length != 0
            ? Column(
                children: [
                  DetailsHeader(
                    header: "Excluded bundles",
                  ),
                  ...getExcludedBundles,
                ],
              )
            : DetailsHeader(header: "No excluded bundles"),
        Container(
          child: Divider(
            color: Colors.grey,
          ),
          margin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
        ),
        getInactiveBundles.length != 0
            ? Column(
                children: [
                  DetailsHeader(
                    header: "Inactive bundles",
                  ),
                  ...getInactiveBundles,
                ],
              )
            : DetailsHeader(header: "No inactive bundles"),
      ],
    );
  }
}
