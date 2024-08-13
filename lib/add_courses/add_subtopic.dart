import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kafundisha/add_courses/add_lesson.dart';
import 'package:kafundisha/models/subtopic.dart';
import 'package:kafundisha/utils/services.dart';

class AddSubtopicPage extends StatefulWidget {
  final String topicId;

  AddSubtopicPage({required this.topicId});

  @override
  _AddSubtopicPageState createState() => _AddSubtopicPageState();
}

class _AddSubtopicPageState extends State<AddSubtopicPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _indexController = TextEditingController();
  final Services _firebaseService = Services();

  void _addSubtopic() async {
    String subtopicId = _titleController.text.replaceAll(' ', '_').toLowerCase();
    int index = int.parse(_indexController.text);
    Subtopic subtopic = Subtopic(id: subtopicId, name: _titleController.text, index: index, topicId: widget.topicId);
    await _firebaseService.addSubtopic(subtopic);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Subtopic added successfully!')));

    // Navigate to AddLessonPage with subtopicId
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddLessonPage(subtopicId: subtopicId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Subtopic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Subtopic Title'),
            ),
            TextField(
              controller: _indexController,
              decoration: InputDecoration(labelText: 'Index'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addSubtopic,
              child: Text('Add Subtopic and Continue to Add Lesson'),
            ),
          ],
        ),
      ),
    );
  }
}