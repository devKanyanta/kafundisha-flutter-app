class Lesson {
  final String id;
  final String subtopicId;
  final String title;
  final String content;

  Lesson({required this.id, required this.subtopicId, required this.title, required this.content});

  factory Lesson.fromMap(Map<String, dynamic> data, String documentId) {
    return Lesson(
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
