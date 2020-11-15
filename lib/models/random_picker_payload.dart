class RandomPickerPayload {
  String id;

  RandomPickerPayload({
    this.id,
  });

  Map toJson() {
    return {
      "id": id,
      "content": {
        "forceCycle": true,
      },
    };
  }
}
