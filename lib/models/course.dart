class Course {
  String id;
  String name;
  String description;

  Course({required this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Course{id: $id, name: $name, description: $description}';
  }
}