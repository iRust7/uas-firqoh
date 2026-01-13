import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String content;

  @HiveField(3)
  late String tag;

  @HiveField(4)
  late bool isPinned;

  @HiveField(5)
  late int updatedAt;

  @HiveField(6)
  late int colorIndex;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.tag,
    this.isPinned = false,
    required this.updatedAt,
    this.colorIndex = 0,
  });

  // Factory constructor for creating new notes
  factory Note.create({
    required String title,
    required String content,
    required String tag,
    bool isPinned = false,
    int colorIndex = 0,
  }) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return Note(
      id: timestamp.toString(),
      title: title,
      content: content,
      tag: tag,
      isPinned: isPinned,
      updatedAt: timestamp,
      colorIndex: colorIndex,
    );
  }

  // Copy with method for updates
  Note copyWith({
    String? title,
    String? content,
    String? tag,
    bool? isPinned,
    int? colorIndex,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      tag: tag ?? this.tag,
      isPinned: isPinned ?? this.isPinned,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }

  // Format updated date for display
  String get formattedDate {
    final date = DateTime.fromMillisecondsSinceEpoch(updatedAt);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
