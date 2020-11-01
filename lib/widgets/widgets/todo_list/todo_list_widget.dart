import 'package:cogboardmobileapp/models/todo_list_item_model.dart';
import 'package:cogboardmobileapp/models/widget_model.dart';
import 'package:cogboardmobileapp/widgets/widgets/details_container.dart';
import 'package:cogboardmobileapp/widgets/widgets/todo_list/todo_list_item.dart';
import 'package:flutter/material.dart';

class TodoListWidget extends StatelessWidget {
  final DashboardWidget widget;

  TodoListWidget({
    this.widget,
  }) {
    getTodoItems;
  }

  List<TodoListItemModel> get getTodoItems {
    var todoItems = widget.toDoListItems;
    var notSelectedItems = todoItems
        .where((item) => !getSelectedItems.contains(
              item['id'],
            ))
        .toList();
    var selectedItems = todoItems
        .where((item) => getSelectedItems.contains(
              item['id'],
            ))
        .toList();
    var itemsOrder = [...notSelectedItems, ...selectedItems];
    return itemsOrder
        .map((item) => TodoListItemModel(
              itemText: item['itemText'],
              id: item['id'],
            ))
        .toList();
  }

  List get getSelectedItems {
    return widget.content['selectedItems'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DetailsContainer(
        children: [
          ...getTodoItems
              .map((item) => TodoListItem(
                    itemText: item.itemText,
                    id: item.id,
                    widgetId: widget.id,
                    initiallySelected: getSelectedItems.contains(item.id),
                  ))
              .toList(),
        ],
      ),
      margin: const EdgeInsets.fromLTRB(15.0, 20.0, 0, 0),
    );
  }
}
