import 'package:flutter/material.dart';
import 'package:kafundisha/models/lesson.dart';
import 'package:kafundisha/utils/services.dart';

class AddLessonPage extends StatefulWidget {
  final String subtopicId;

  AddLessonPage({required this.subtopicId});

  @override
  _AddLessonPageState createState() => _AddLessonPageState();
}

class _AddLessonPageState extends State<AddLessonPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _indexController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Services _firebaseService = Services();

  void _addLesson() async {
    String lessonId = _titleController.text.replaceAll(' ', '_').toLowerCase();
    int index = int.parse(_indexController.text);
    LessonModel lesson = LessonModel(id: lessonId, name: _titleController.text, index: index, subtopicId: widget.subtopicId, description: _descriptionController.text);
    await _firebaseService.addLesson(lesson);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lesson added successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Lesson'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Lesson Title'),
            ),
            TextField(
              controller: _indexController,
              decoration: InputDecoration(labelText: 'Index'),
              keyboardType: TextInputType.number,
            ),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addLesson,
              child: Text('Add Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}
