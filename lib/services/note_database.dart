import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_tutorial/models/note_model.dart';
import 'package:supabase_tutorial/services/user_database.dart';
import 'package:supabase_tutorial/utils.dart';

class NoteDatabase {
  final db = Supabase.instance.client.from(Tables.notes.name);

  // add note to notes database
  Future createNote(NoteModel note) async {
    await db.insert(note.toMap());
  }

  // get notes from database
  Stream<List<NoteModel>> getNotes() async* {
    final userId = await UserDatabase().getCurrentUserId(
        Supabase.instance.client.auth.currentUser?.email ?? '');

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
