class UrlPreferences {
  List<String> favouriteWidgetIds = [];
  List<String> quarantineWidgetIds = [];

  UrlPreferences({this.favouriteWidgetIds, this.quarantineWidgetIds});

  factory UrlPreferences.fromJson(Map<String, dynamic> json) => UrlPreferences(
        favouriteWidgetIds: (json['favouriteWidgetIds'] as List<dynamic>).cast<String>(),
        quarantineWidgetIds: (json['quarantineWidgetIds'] as List<dynamic>).cast<String>(),
      );

  Map<String, dynamic> toJson() {
    return {
      'favouriteWidgetIds': favouriteWidgetIds,
      'quarantineWidgetIds': quarantineWidgetIds,
    };
  }
}
