import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/utils/url_launcher.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_header.dart';
import 'package:cogboardmobileapp/widgets/widgets/widget_details_item.dart';
import 'package:flutter/material.dart';

class AemBundleInfoWidget extends StatelessWidget with UrlLauncher {
  final DashboardWidget widget;

  AemBundleInfoWidget({
    @required this.widget,
  });

  void openUrl(BuildContext context) {
    launchUrl(widget.content['url'], context);
  }

  List getBundleStatus(BuildContext context) {
    Map status = widget.content["bundleStatus"];
    return status.entries
        .map((item) => GestureDetector(
              onTap: () => openUrl(context),
              child: WidgetDetailsItem(
                detail: "${item.key.toString().toUpperCase()}: ${item.value}",
              ),
            ))
        .toList();
  }

  List getExcludedBundles(BuildContext context) {
    List bundles = widget.content["excludedBundles"];
    return bundles
        .map(
          (bundle) => GestureDetector(
            onTap: () => openUrl(context),
            child: WidgetDetailsItem(
              detail: "$bundle",
            ),
          ),
        )
        .toList();
  }

  List getInactiveBundles(BuildContext context) {
    List bundles = widget.content["inactiveBundles"];
    return bundles
        .map(
          (bundle) => GestureDetector(
            onTap: () => openUrl(context),
            child: WidgetDetailsItem(
              detail: "$bundle",
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsContainer(
      children: [
        Container(
          child: Column(
            children: [
              ...getBundleStatus(context),
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
        getExcludedBundles(context).length != 0
            ? Column(
                children: [
                  DetailsHeader(
                    header: AppLocalizations.of(context).getTranslation('aemBundleInfo.exludedBundles'),
                  ),
                  ...getExcludedBundles(context),
                ],
              )
            : DetailsHeader(header: AppLocalizations.of(context).getTranslation('aemBundleInfo.noExcludedBundles')),
        Container(
          child: Divider(
            color: Colors.grey,
          ),
          margin: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
        ),
        getInactiveBundles(context).length != 0
            ? Column(
                children: [
                  DetailsHeader(
                    header: AppLocalizations.of(context).getTranslation('aemBundleInfo.inactiveBundles'),
                  ),
                  ...getInactiveBundles(context),
                ],
              )
            : DetailsHeader(header: AppLocalizations.of(context).getTranslation('aemBundleInfo.noInactiveBundles')),
      ],
    );
  }
}
