class Topic {
  final String id;
  final String name;
  // Add other fields as necessary

  Topic({required this.id, required this.name});

  factory Topic.fromMap(Map<String, dynamic> data, String id) {
    return Topic(
      id: id,
      name: data['name'] ?? '',
      // Initialize other fields
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // Add other fields
    };
  }

  @override
  String toString() {
    return 'Topic{id: $id, name: $name}';
  }
}
