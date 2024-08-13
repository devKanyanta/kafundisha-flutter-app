import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:kafundisha/models/course.dart';
import 'package:kafundisha/utils/services.dart';
import 'package:kafundisha/views/topics.dart';

class SearchModal extends StatefulWidget {
  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  List<Course> _courses = [];
  TextEditingController _controller = TextEditingController();

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _courses = [];
      });
    } else {
      List<Course> courses = await Services().searchCourses(query);
      setState(() {
        _courses = courses;
      });
    }
  }

  bool isCourseEmpty = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(

                hintText: 'Search courses...',
              ),
              onChanged: (query) {
                _search(query);
                if(_courses.isNotEmpty) {
                  isCourseEmpty = false;
                } else{
                  isCourseEmpty = true;
                }
                print(_courses);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: !isCourseEmpty ? ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicsScreen(courseId: _courses[index].id),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(_courses[index].name),
                    ),
                  );
                },
              ): const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Sorry, no courses found.',
                    style: TextStyle(
                      color: Colors.black
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}