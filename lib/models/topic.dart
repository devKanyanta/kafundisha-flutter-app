class Topic {
  String id;
  String name;
  int index;
  String courseId;

  Topic({required this.id, required this.name, required this.index, required this.courseId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': name,
      'index': index,
      'courseId': courseId,
    };
  }
}
