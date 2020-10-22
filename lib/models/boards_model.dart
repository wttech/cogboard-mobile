import 'board_model.dart';

class Boards {
  Map<String, Board> boardsById;
  List<String> allBoards;

  Boards({
    this.boardsById,
    this.allBoards
  });

  factory Boards.fromJson(Map<String, dynamic> json) => Boards(
    boardsById: ((json['boardsById']) as Map<String, dynamic>)
        .map((key, value) => MapEntry(key.toString(), Board.fromJson(value))),
    allBoards: ((json['allBoards']) as List<dynamic>).cast<String>()
  );
}