import 'package:flutter/material.dart';
import 'package:kafundisha/models/student.dart';

class StudentProvider with ChangeNotifier {
  Student? _student;

  Student? get student => _student;

  void setStudent(Student student) {
    _student = student;
    notifyListeners();
  }

  void clearStudent() {
    _student = null;
    notifyListeners();
  }
}
