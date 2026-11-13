import 'package:get/get.dart';
import 'package:notyee/screns/NoteListScreen.dart';
import 'package:notyee/screns/NotesDetailsScreen.dart';
import 'package:notyee/screns/SplashScreen.dart';
import 'package:notyee/screns/app_routes.dart';
import 'package:notyee/screns/notes_binding.dart';

class AppPages {
  static final routes = [

    GetPage(name: AppRoutes.splashScreen, page: () => Splashscreen(), binding: NotesBinding()),
    GetPage(name: AppRoutes.noteListScreen, page: () => Notelistscreen(), binding: NotesBinding()),
    GetPage(name: AppRoutes.noteDetailsScreen, page: () => Notesdetailsscreen(), binding: NotesBinding()),
  ];
}