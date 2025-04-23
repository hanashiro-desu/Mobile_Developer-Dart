import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Note.dart';

class NoteAPIService {
  static final NoteAPIService instance = NoteAPIService._init();
  final String baseUrl ='https://api-pd2d.onrender.com';

  NoteAPIService._init();

  Future<List<Note>> getAllNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Note.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load notes: ${response.statusCode}');
    }
  }

  Future<Note?> getNoteById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/notes/$id'));
    if (response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get note: ${response.statusCode}');
    }
  }

  Future<Note> createNote(Note note) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create note: ${response.statusCode}');
    }
  }

  Future<Note> updateNote(Note note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(note.toMap()),
    );
    if (response.statusCode == 200) {
      return Note.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update note: ${response.statusCode}');
    }
  }

  Future<bool> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete note: ${response.statusCode}');
    }
  }

  Future<List<Note>> searchNotes(String query) async {
    final notes = await getAllNotes();
    return notes.where((note) =>
    note.title.toLowerCase().contains(query.toLowerCase()) ||
        note.content.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  Future<List<Note>> getNotesByPriority(int priority) async {
    final notes = await getAllNotes();
    return notes.where((note) => note.priority == priority).toList();
  }
}
