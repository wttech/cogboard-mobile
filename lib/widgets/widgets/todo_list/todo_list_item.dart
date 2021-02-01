import 'dart:convert';

import 'package:cogboardmobileapp/models/todo_item_payload.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TodoListItem extends StatefulWidget {
  final String id;
  final String widgetId;
  final String itemText;
  final bool initiallySelected;

  TodoListItem({
    this.id,
    this.widgetId,
    this.itemText,
    this.initiallySelected,
  });

  @override
  _TodoListItemState createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  bool isSelected;

  @override
  void initState() {
    super.initState();
    this.isSelected = widget.initiallySelected;
  }

  @override
  void didUpdateWidget(TodoListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      isSelected = widget.initiallySelected;
    });
  }

  Future<void> updateItem() async {
    String currentUrl = Provider.of<ConfigProvider>(context, listen: false).currentUrl;
    String url = '$currentUrl/api/widget/contentUpdate';
    TodoUpdatePayload payload = TodoUpdatePayload(
      id: widget.widgetId,
      selectedItem: widget.id,
    );
    await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payload),
    );
  }

  void handleCheckboxUpdate() {
    setState(() {
      isSelected = !isSelected;
    });
    updateItem();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: null,
          ),
          Text(
            widget.itemText,
            style: TextStyle(
              fontSize: 17,
              decoration: isSelected ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
      onTap: handleCheckboxUpdate,
    );
  }
}
