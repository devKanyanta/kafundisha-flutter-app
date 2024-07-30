import 'package:kafundisha/models/topic.dart';

class Course {
  String id;
  String name;
  String description;
  double rating;
  List<Topic> topics;

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.topics,
  });

  factory Course.fromMap(Map<String, dynamic> map, String documentId) {
    // Check if the map contains a list of topics and convert each one
    var topicsList = (map['topics'] as List<dynamic>?)
        ?.map((topicMap) => Topic.fromMap(topicMap as Map<String, dynamic>, topicMap['id'] as String))
        .toList() ?? [];

    return Course(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      topics: topicsList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'rating': rating,
      'topics': topics.map((topic) => topic.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Course{id: $id, name: $name, description: $description, rating: $rating, topics: $topics}';
  }
}
