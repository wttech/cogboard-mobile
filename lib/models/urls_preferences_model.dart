import 'package:cogboardmobileapp/models/url_preferences_model.dart';

class UrlsPreferences {
  static const String KEY = 'UrlsPreferences';
  Map<String,UrlPreferences> urls;
  int version;


  UrlsPreferences({this.urls, this.version});

  factory UrlsPreferences.fromJson(Map<String, dynamic> json) => UrlsPreferences(
    urls: ((json['urls']) as Map<String, dynamic>)
        .map((key, value) => MapEntry(key.toString(), UrlPreferences.fromJson(value))),
    version: json['version'],
  );

  Map<String, dynamic> toJson() {
    return {
      'urls': urls.map((key, value) => MapEntry(key, value.toJson())),
      'version': version,
    };
  }
}
