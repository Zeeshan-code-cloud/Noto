import 'package:get/get.dart';
import 'package:notyee/screns/controllers.dart';

class NotesBinding  extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.put(NotesController(), permanent: true);
  }

}