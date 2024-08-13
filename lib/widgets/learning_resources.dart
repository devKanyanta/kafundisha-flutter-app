import 'package:flutter/material.dart';

class LearningResources extends StatelessWidget {
  final List<String> savedMaterials = ["Lesson 1 Notes", "Math Video", "Science Article"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Saved Materials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: savedMaterials.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(savedMaterials[index]),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Remove item logic
                },
              ),
            );
          },
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(labelText: 'Personal Notes'),
        ),
      ],
    );
  }
}
