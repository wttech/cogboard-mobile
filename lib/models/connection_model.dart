import 'package:flutter/rendering.dart';

class Connection {
  final int id;
  final String url;
  final int lastVisited;

  Connection({this.id, this.url, this.lastVisited});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'url': url, 'lastVisited': lastVisited};

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  String toString() {
    return "Connection $id: $url $lastVisited";
  }
}
