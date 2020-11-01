class TodoUpdatePayload {
  String id;
  String selectedItem;

  TodoUpdatePayload({
    this.id,
    this.selectedItem,
  });

  Map toJson() {
    return {
      "id": id,
      "selectedItem": selectedItem,
    };
  }
}
