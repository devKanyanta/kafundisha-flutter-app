import 'package:flutter/material.dart';
import 'package:kafundisha/add_courses/add_subtopic.dart';
import 'package:kafundisha/models/course.dart';
import 'package:kafundisha/models/topic.dart';
import 'package:kafundisha/provider/course.dart';
import 'package:kafundisha/utils/services.dart';
import 'package:provider/provider.dart';

class AddTopicPage extends StatefulWidget {
  AddTopicPage();

  @override
  _AddTopicPageState createState() => _AddTopicPageState();
}

class _AddTopicPageState extends State<AddTopicPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _indexController = TextEditingController();
  final Services _firebaseService = Services();
  List<Topic> topics = [];

  late Future<void> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = Provider.of<CourseProvider>(context, listen: false).loadCourses();
  }

  void _addTopics(){
    String topicId = _titleController.text.replaceAll(' ', '_').toLowerCase();
    int index = int.parse(_indexController.text);
    Topic topic = Topic(id: topicId, name: _titleController.text, index: index, courseId: '');
    setState(() {
      topics.add(topic);
      _titleController.clear();
      _indexController.clear();
    });
  }

  void _addTopic() async {


    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Topic added successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    String? _selectedCourse;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: _firebaseService.fetchCourseDropdownItems(), // Use the updated function here
              builder: (BuildContext context, AsyncSnapshot<List<DropdownMenuItem<String>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No courses available');
                } else {
                  return DropdownButton<String>(
                    hint: Text('Select a course'),
                    items: snapshot.data, // Use the items directly
                    onChanged: (String? selectedCourseName) {
                      setState(() {
                        _selectedCourse = selectedCourseName;
                      });
                    },
                    value: _selectedCourse, // The currently selected course name
                  );
                }
              },
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Topic Title'),
            ),
            TextField(
              controller: _indexController,
              decoration: InputDecoration(labelText: 'Index'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTopic,
              child: Text('Add Topic and Continue to Add Subtopic'),
            ),
          ],
        ),
      ),
    );
  }
}