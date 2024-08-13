class Subtopic {
  String id;
  String name;
  int index;
  String topicId;

  Subtopic({required this.id, required this.name, required this.index, required this.topicId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': name,
      'index': index,
      'topicId': topicId,
    };
  }
}
