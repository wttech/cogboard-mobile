class CheckboxUpdatePayload {
  String id;
  String widgetStatus;

  CheckboxUpdatePayload({
    this.id,
    this.widgetStatus,
  });

  Map toJson() {
    return {
      "id": id,
      "content": {
        "widgetStatus": widgetStatus,
      },
    };
  }
}
