class NoteModel {
  final int? id;
  final String content;
  final int userId;

  NoteModel({required this.userId, this.id, required this.content});

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
        id: map['id'] as int,
        content: map['content'] as String,
        userId: map['user_id'] as int);
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'user_id': userId,
    };
  }
}
