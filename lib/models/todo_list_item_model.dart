class TodoListItemModel {
  String id;
  String itemText;

  TodoListItemModel({
    this.id,
    this.itemText,
  });

  factory TodoListItemModel.fromJson(Map<String, dynamic> json) => TodoListItemModel(
        id: json['id'],
        itemText: json['itemText'],
      );

  Map toJson() {
    return {
      "id": id,
      "itemText": itemText,
    };
  }

  factory TodoListItemModel.deepCopy(TodoListItemModel model) => new TodoListItemModel(
        id: model.id,
        itemText: model.itemText,
      );
}
