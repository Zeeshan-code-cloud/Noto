import 'dart:io';

import 'package:flutter/cupertino.dart' show TextEditingController;
import 'package:flutter/widgets.dart' show UndoHistoryController;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_permission/smart_permission.dart';

import '../model/note_model.dart';
import '../model/storage_services.dart';
import 'app_routes.dart';

class NotesController extends GetxController {

  RxList<NoteModel> allNotes = <NoteModel>[].obs;
  
  RxString searchQuery = ''.obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final UndoHistoryController undoController = UndoHistoryController();


  Rxn<File> selectedImage = Rxn<File>();
  Rxn<NoteModel> editingNote = Rxn<NoteModel>();

  @override
  void onInit() {
    super.onInit();
    getAllNotes();
  }

  @override
  void onReady() {
    super.onReady();
    moveNoteListscreen();
    // Removed so we don't automatically navigate if we shouldn't? Or wait, maybe this was for a splash screen?
    // Actually, wait, let's keep it if they had it for splash.
  }

  void moveNoteListscreen() {
    Future.delayed(Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.noteListScreen);
    });
  }

  String getTimeLabel(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return '$difference Days Ago';
  }
  
  List<NoteModel> get filteredNotes {
    if (searchQuery.value.isEmpty) {
      return allNotes;
    }
    return allNotes.where((note) =>
        note.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        note.description.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }

  Future<void> pickImage() async {
  SmartPermissionResult res = await   SmartPermission.requestResult(permission: Permission.photos);
  if(res.isGranted){
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }
  else if(res.isPermanentlyDenied){
  await   openAppSettings();
  }

  }
  
  void removeImage() {
    selectedImage.value = null;
  }

  void openNewNote() {
    editingNote.value = null;
    titleController.clear();
    noteController.clear();
    selectedImage.value = null;
    Get.toNamed(AppRoutes.noteDetailsScreen);
  }

  void openEditNote(NoteModel note) {
    editingNote.value = note;
    titleController.text = note.title;
    noteController.text = note.description;
    selectedImage.value = note.imagePath != null ? File(note.imagePath!) : null;
    Get.toNamed(AppRoutes.noteDetailsScreen);
  }

  Future addOrUpdateNotes() async {
    if (editingNote.value != null) {
      await updateNotes(editingNote.value!);
    } else {
      await addNotes();
    }
    await getAllNotes();
    Get.back();
  }

  Future addNotes() async {
    await NotesService.instance.addNote(
      NoteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: titleController.text.isEmpty ? "Untitled" : titleController.text,
        description: noteController.text,
        imagePath: selectedImage.value?.path,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future getAllNotes() async {
    final notes = await NotesService.instance.getNotes();
    // Sort by created at descending
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    allNotes.value = notes;
  }

  Future updateNotes(NoteModel note) async {
    await NotesService.instance.updateNote(
      note.copyWith(
        title: titleController.text.isEmpty ? "Untitled" : titleController.text,
        description: noteController.text,
        imagePath: selectedImage.value?.path,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future deleteNote(NoteModel note) async {
    await NotesService.instance.deleteNote(note.id);
    await getAllNotes();
  }
  
  Future deleteCurrentNote() async {
    if (editingNote.value != null) {
      await deleteNote(editingNote.value!);
      Get.back();
    }
  }
}
