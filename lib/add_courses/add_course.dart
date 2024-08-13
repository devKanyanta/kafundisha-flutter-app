import 'package:flutter/material.dart';
import 'package:kafundisha/add_courses/add_topic.dart';
import 'package:kafundisha/models/course.dart';
import 'package:kafundisha/utils/services.dart';

class AddCoursePage extends StatefulWidget {
  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Services _firebaseService = Services();
  List<Course> courses = [];

  void _uploadCourses() async {

    await _firebaseService.addCourses(courses);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Courses added successfully!')));

  }


  void _addCourses() {
    // Generate a course ID by replacing spaces with underscores and converting to lowercase
    String courseId = _titleController.text.trim().replaceAll(' ', '_').toLowerCase();

    // Create a Course object with the generated ID, name, and description
    Course course = Course(
      id: courseId,
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    // Add the course to the list of courses
    if (courses != null) {
      courses!.add(course);
    } else {
      courses = [course];
    }

    // Clear the text fields and update the UI
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courses.toString()
            ),
            ElevatedButton(
              onPressed: (){
                if(courses!=null)
                  courses?.clear();
              },
              child: const Text('Clear courses list'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Course Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Course Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCourses,
              child: const Text('Add Course to list'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadCourses,
              child: const Text('Upload courses to database'),
            ),
          ],
        ),
      ),
    );
  }
}