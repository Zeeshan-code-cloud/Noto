import 'dart:io';
import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/NotesModel.dart';
import 'NotesDetailsScreen.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  late Box<Note> notesBox;
  late Box favoritesBox;

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notes');
    favoritesBox = Hive.box('favorites');
  }

  String formatNoteDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("My Notes"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height*0.75,
            left: MediaQuery.of(context).size.width*0.00775,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepPurple],
                ),
              ),
              child: Icon(Icons.edit, size: 100, color: Colors.white70),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.75,
            left: MediaQuery.of(context).size.width*0.43,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrangeAccent],
                ),
              ),
              child: Icon(Icons.menu_book, size: 100, color: Colors.white70),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height*0.64,
            left: MediaQuery.of(context).size.width*0.25,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.blueAccent],
                ),
              ),
              child: Icon(Icons.note_alt, size: 80, color: Colors.white70),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),

          ValueListenableBuilder(
            valueListenable: notesBox.listenable(),
            builder: (context, Box<Note> box, _) {
              if (box.values.isEmpty) {
                return Center(child: Text("No notes yet.", style: TextStyle(color: Colors.white, fontSize: 18)));
              }
              List<MapEntry<dynamic, Note>> notes = box.toMap().entries.toList();
              notes.sort((a, b) => b.value.created.compareTo(a.value.created));

              String? lastDateLabel;
              return ListView.builder(
                padding: EdgeInsets.only(top: kToolbarHeight + 16, bottom: 80),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final entry = notes[index];
                  final note = entry.value;
                  final noteDate = formatNoteDate(note.created);
                  final showDateLabel = noteDate != lastDateLabel;
                  lastDateLabel = noteDate;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDateLabel)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: Text(
                            noteDate,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NoteDetailsScreen(note: note),
                          ),
                        ),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Delete Note"),
                              content: Text("Are you sure you want to delete this note?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    note.delete();
                                    Navigator.pop(context);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          clipBehavior: Clip.antiAlias,
                          child: Container(

                            decoration: note.imagePath != null
                                ? BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(note.imagePath!)),
                                fit: BoxFit.cover,
                              ),
                            )
                                : BoxDecoration(color: Colors.grey[300]),
                            child: Container(
                              color: Colors.black.withOpacity(0.4),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      note.title,
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    formatTime(note.created),
                                    style: TextStyle(color: Colors.white70, fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NoteDetailsScreen()),
        ),
      ),
    );
  }
}
