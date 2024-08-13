import 'package:flutter/material.dart';
import 'package:kafundisha/add_courses/add_course.dart';
import 'package:kafundisha/add_courses/add_lesson.dart';
import 'package:kafundisha/add_courses/add_subtopic.dart';
import 'package:kafundisha/add_courses/add_topic.dart';

class UploadContent extends StatefulWidget {
  const UploadContent({super.key});

  @override
  State<UploadContent> createState() => _UploadContentState();
}

class _UploadContentState extends State<UploadContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kafundisha Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddCoursePage()));
              },
              child: Text('Add Courses'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddTopicPage()));
              },
              child: Text('Add Topics'),
            ),
          ],
        ),
      ),
    );
  }
}