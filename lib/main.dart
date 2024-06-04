import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NoteHomePage(),
    );
  }
}

class NoteHomePage extends StatefulWidget {
  const NoteHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoteHomePageState createState() => _NoteHomePageState();
}

class _NoteHomePageState extends State<NoteHomePage> {
  final TextEditingController _noteController = TextEditingController();
  final List<String> _notes = [];
  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes.addAll(prefs.getStringList('notes') ?? []);
    });
  }

  _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', _notes);
  }

  _addNote() {
    String newNote = _noteController.text;
    if (newNote.isNotEmpty) {
      setState(() {
        _notes.add(newNote);
      });
      _noteController.clear();
      _saveNotes();
    }
  }

  _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Taking App'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notes[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteNote(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Add a new note',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNote,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
