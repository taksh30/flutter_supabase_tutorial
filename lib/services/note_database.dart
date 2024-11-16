import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_tutorial/models/note_model.dart';
import 'package:supabase_tutorial/services/auth_service.dart';
import 'package:supabase_tutorial/services/user_database.dart';

class NoteDatabase {
  final db = Supabase.instance.client.from('notes');

  // add note to notes database
  Future createNote(NoteModel note) async {
    await db.insert(note.toMap());
  }

  // get notes from database
  Stream<List<NoteModel>> getNotes() async* {
    final userEmail = AuthService().getCurrentUserEmail();
    final userId = await UserDatabase().getCurrentUserId(userEmail ?? '');

    yield* Supabase.instance.client
        .from('notes')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('id')
        .map((data) =>
            data.map((noteMap) => NoteModel.fromMap(noteMap)).toList());
  }

  // update note
  Future updateNote(NoteModel oldNote, String newContent) async {
    var note = NoteModel(content: newContent, userId: oldNote.userId);
    await db.update(note.toMap()).eq('id', oldNote.id!);
  }

  // delete note by id
  Future deleteNote(NoteModel note) async {
    await db.delete().eq('id', note.id ?? '');
  }
}
