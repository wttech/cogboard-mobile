import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Connection {
  final String url;
//  final bool lastVisited;
  final String name;
  bool isActive;

  Connection({this.url, this.name, this.isActive});

  Map<String, dynamic> toJson() => {
        'url': url,
//        'lastVisited': lastVisited,
        'name': name,
        'isActive': isActive,
      };

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      url: json['url'],
//      lastVisited: json['lastVisited'],
      name: json['name'],
      isActive: json['isActive'],
    );
  }

}
