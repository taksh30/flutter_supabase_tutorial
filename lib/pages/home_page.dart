import 'package:flutter/material.dart';
import 'package:supabase_tutorial/models/note_model.dart';
import 'package:supabase_tutorial/services/auth_service.dart';
import 'package:supabase_tutorial/services/note_database.dart';
import 'package:supabase_tutorial/services/user_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _noteCtr = TextEditingController();
  final authService = AuthService();
  final noteDB = NoteDatabase();
  final userDB = UserDatabase();

  // delete the note
  Future<void> _deleteNote(NoteModel note) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await noteDB.deleteNote(note);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete note')),
          );
        }
      }
    }
  }

  // add and update the note
  void _addAndUpdateNote({NoteModel? note}) {
    if (note != null) {
      _noteCtr.text = note.content;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note != null ? 'Update Note' : 'Add Note'),
        content: TextField(
          controller: _noteCtr,
          decoration: InputDecoration(
            hintText: 'Write Note',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _noteCtr.clear();
            },
            child: Text(
              'Cancel',
            ),
          ),
          TextButton(
            onPressed: () async {
              if (note != null) {
                await noteDB.updateNote(note, _noteCtr.text);
              } else {
                await _onAdd(context);
              }

              Navigator.pop(context);

              _noteCtr.clear();
            },
            child: Text(
              note != null ? 'Update' : 'Add',
            ),
          ),
        ],
      ),
    );
  }

  // on button pressed
  Future<void> _onAdd(BuildContext context) async {
    final userEmail = authService.getCurrentUserEmail();
    final userId = await userDB.getCurrentUserId(userEmail ?? '');
    final note = NoteModel(content: _noteCtr.text, userId: userId);

    await noteDB.createNote(note);
  }

  // sign out
  void _logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = authService.getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUserEmail ?? 'Notes'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            onPressed: () {
              _logout();
            },
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),

      // stream the data
      body: StreamBuilder<List<NoteModel>>(
        stream: noteDB.getNotes(),
        builder: (context, snapshot) {
          // loading data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // error
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong!'),
            );
          }

          final notes = snapshot.data;

          // when notes are empty
          if (notes == null || notes.isEmpty) {
            return Center(
              child: Text(
                'No notes added yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // listview
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              // listtile
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Card(
                  child: ListTile(
                    title: Text(note.content),
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        children: [
                          // add and update button
                          IconButton(
                            onPressed: () {
                              _addAndUpdateNote(note: note);
                            },
                            icon: Icon(
                              Icons.edit,
                            ),
                          ),

                          // delete button
                          IconButton(
                            onPressed: () {
                              _deleteNote(note);
                            },
                            icon: Icon(
                              Icons.delete,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      // floatingactionbutton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addAndUpdateNote();
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
