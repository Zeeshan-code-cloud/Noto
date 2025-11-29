import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import '../model/NotesModel.dart';
import 'package:intl/intl.dart';

class NoteDetailsScreen extends StatefulWidget {
  final Note? note;
  NoteDetailsScreen({this.note});

  @override
  _NoteDetailsScreenState createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final undoStack = <String>[];
  final redoStack = <String>[];
  String? imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      imagePath = widget.note!.imagePath;
    }
    contentController.addListener(() {
      setState(() {});
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imagePath = picked.path);
    }
  }

  void _undo() {
    if (undoStack.isNotEmpty) {
      redoStack.add(contentController.text);
      contentController.text = undoStack.removeLast();
    }
  }

  void _redo() {
    if (redoStack.isNotEmpty) {
      undoStack.add(contentController.text);
      contentController.text = redoStack.removeLast();
    }
  }

  void _saveNote() {
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    if (title.isEmpty || content.isEmpty) return;
    final noteBox = Hive.box<Note>('notes');

    if (widget.note == null) {
      final note = Note(
        id:  "Uuid().v4()",
        title: title,
        content: content,
        created: DateTime.now(),
        imagePath: imagePath,
      );
      noteBox.add(note);
    } else {
      widget.note!
        ..title = title
        ..content = content
        ..imagePath = imagePath
        ..created = DateTime.now()
        ..save();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat.yMd().add_jm().format(now);
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.note == null ? "New Note" : "Edit Note", style: TextStyle(color: Colors.white),),
        actions: [IconButton(icon: Icon(Icons.save, color: Colors.white), onPressed: _saveNote)],
      ),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height*0.64,
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
            top: MediaQuery.of(context).size.height*0.64,
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
            top: MediaQuery.of(context).size.height*0.55,
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
          Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 8),
                  Text(dateStr, style: TextStyle(color: Colors.white),),
                  Spacer(),
                  Text("Chars: ${contentController.text.length}" , style: TextStyle(color: Colors.white),),
                  IconButton(onPressed: _undo, icon: Icon(Icons.undo, color: Colors.white)),
                  IconButton(onPressed: _redo, icon: Icon(Icons.redo ,color: Colors.white)),
                  IconButton(onPressed: _pickImage, icon: Icon(Icons.image ,color: Colors.white)),
                  SizedBox(width: 8),
                ],
              ),
              if (imagePath != null)
                Image.file(
                  File(imagePath!),
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: contentController,
                    style: TextStyle(color: Colors.white),
                    maxLines: null,
                    onChanged: (val) {
                      undoStack.add(val);
                    },
                    decoration: InputDecoration(hintText: 'Type your note...'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),


        );

  }
}
