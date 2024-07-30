import 'package:kafundisha/models/lesson.dart';

class Subtopic {
  final String id;
  final String topicId;
  final String name;
  final String description;

  Subtopic({required this.id, required this.topicId, required this.name, required this.description});

  factory Subtopic.fromMap(Map<String, dynamic> data, String documentId) {
    return Subtopic(
      id: documentId,
      topicId: data['topicId'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topicId': topicId,
      'name': name,
      'description': description,
    };
  }
}
