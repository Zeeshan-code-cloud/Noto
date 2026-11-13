
import 'package:notyee/model/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotesService {
  NotesService._();

  static final NotesService instance = NotesService._();

  static const String notesKey = 'notes';

  /// Get SharedPreferences
  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  /// Get All Notes
  Future<List<NoteModel>> getNotes() async {
    final prefs = await _prefs;

    final List<String> notesJson =
        prefs.getStringList(notesKey) ?? [];

    return notesJson
        .map((e) => NoteModel.fromJson(e))
        .toList();
  }

  /// Add Note
  Future<void> addNote(NoteModel note) async {
    final prefs = await _prefs;

    final notes = await getNotes();

    notes.add(note);

    await prefs.setStringList(
      notesKey,
      notes.map((e) => e.toJson()).toList(),
    );
  }

  /// Update Note
  Future<void> updateNote(NoteModel updatedNote) async {
    final prefs = await _prefs;

    final notes = await getNotes();

    final index =
    notes.indexWhere((e) => e.id == updatedNote.id);

    if (index != -1) {
      notes[index] = updatedNote;

      await prefs.setStringList(
        notesKey,
        notes.map((e) => e.toJson()).toList(),
      );
    }
  }

  /// Delete Note
  Future<void> deleteNote(String noteId) async {
    final prefs = await _prefs;

    final notes = await getNotes();

    notes.removeWhere((e) => e.id == noteId);

    await prefs.setStringList(
      notesKey,
      notes.map((e) => e.toJson()).toList(),
    );
  }

  /// Get Single Note
  Future<NoteModel?> getNoteById(String id) async {
    final notes = await getNotes();

    try {
      return notes.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Clear All Notes
  Future<void> clearNotes() async {
    final prefs = await _prefs;
    await prefs.remove(notesKey);
  }
}