class LessonModel {
  String id;
  String name;
  int index;
  String description;
  String subtopicId;

  LessonModel({required this.id, required this.name, required this.index, required this.description, required this.subtopicId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': name,
      'index': index,
      'description': description,
      'subtopicId': subtopicId,
    };
  }
}