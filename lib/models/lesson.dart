class LessonModel {
  final String id;
  final String subtopicId;
  final String title;
  final String content;

  LessonModel({required this.id, required this.subtopicId, required this.title, required this.content});

  factory LessonModel.fromMap(Map<String, dynamic> data, String documentId) {
    return LessonModel(
      id: documentId,
      subtopicId: data['subtopicId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subtopicId': subtopicId,
      'title': title,
      'content': content,
    };
  }
}
