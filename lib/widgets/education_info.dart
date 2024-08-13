import 'package:flutter/material.dart';

class EducationalInformation extends StatelessWidget {
  final List<String> currentCourses = ["Math", "Science", "History"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Current Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currentCourses.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(currentCourses[index]),
                subtitle: LinearProgressIndicator(value: 0.7), // Example progress
              );
            },
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(labelText: 'Learning Goals'),
        ),
      ],
    );
  }
}
