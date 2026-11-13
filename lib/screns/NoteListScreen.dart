
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
 import 'package:notyee/screns/controllers.dart';
import '../model/note_model.dart';

class Notelistscreen extends GetView<NotesController> {
  const Notelistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8FC),

      floatingActionButton: FloatingActionButton(
        onPressed: controller.openNewNote,
        backgroundColor: const Color(0xFF7C5CFF),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notyee',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff0F172A),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Search Field
              TextField(
                onChanged: (val) => controller.searchQuery.value = val,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Notes List
              Expanded(
                child: Obx(() {
                  if (controller.allNotes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 90,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No Notes Yet",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Tap + to create your first note",
                          ),
                        ],
                      ),
                    );
                  }

                  final notes = controller.filteredNotes;
                  if (notes.isEmpty) {
                     return const Center(child: Text("No results found."));
                  }

                  final listItems = <Widget>[];
                  String? lastLabel;

                  for (var note in notes) {
                    final label = controller.getTimeLabel(note.createdAt);
                    if (label != lastLabel) {
                      listItems.add(_sectionTitle(label));
                      lastLabel = label;
                    }
                    listItems.add(_noteTile(note));
                  }

                  return ListView(
                    children: listItems,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _noteTile(NoteModel note) {
    return Dismissible(
      key: Key(note.id),
      direction: DismissDirection.endToStart,
      
      onDismissed: (_) {
         controller.deleteNote(note);
      },

      confirmDismiss: (direction) async {
        return await showDialog(
          context: Get.context!,
          builder: (_) => AlertDialog(
            title: const Text("Delete Note"),
            content: const Text(
              "Are you sure you want to delete this note?",
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(Get.context!, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pop(Get.context!, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        );
      },

      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),

      child: InkWell(
        onTap: () {
          controller.openEditNote(note);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      note.description.isEmpty ? "No description" : note.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      DateFormat('hh:mm a').format(note.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              if (note.imagePath != null && note.imagePath!.isNotEmpty)
                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(10),
                  child: Image.file(
                    File(note.imagePath!),
                    height: 55,
                    width: 55,
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

