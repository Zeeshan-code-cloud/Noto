import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
  import 'package:notyee/screns/SplashScreen.dart';
import 'package:notyee/screns/app_pages.dart';
import 'package:notyee/screns/app_routes.dart';
import 'package:notyee/screns/notes_binding.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Note App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Splashscreen(),
      debugShowCheckedModeBanner: false,
      initialBinding: NotesBinding(),
      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.routes,

    );
  }
}

