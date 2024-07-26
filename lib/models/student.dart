class Student {
  String uid;
  String name;
  String email;
  List<String> courses;
  int age;
  String gender;
  String profileUrl;
  DateTime? createdAt;

  Student({
    required this.uid,
    required this.name,
    required this.email,
    required this.courses,
    required this.age,
    required this.gender,
    required this.profileUrl,
    this.createdAt,
  });

  factory Student.fromMap(String uid, Map<String, dynamic> data) {
    return Student(
      uid: uid,
      name: data['name'],
      email: data['email'],
      courses: List<String>.from(data['courses']),
      age: data['age'],
      gender: data['gender'],
      profileUrl: data['profileUrl'],
      createdAt: data['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'courses': courses,
      'age': age,
      'gender': gender,
      'profileUrl': profileUrl,
      'createdAt': createdAt,
    };
  }
}
