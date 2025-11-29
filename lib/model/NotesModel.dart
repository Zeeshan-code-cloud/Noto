import 'package:hive/hive.dart';
part 'NotesModel.g.dart';


@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime created;

  @HiveField(4)
  String? imagePath;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.created,
    this.imagePath,
  });
}
