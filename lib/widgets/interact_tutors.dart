import 'package:flutter/material.dart';

class InteractionWithTutors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Messages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Message from Tutor A'),
          subtitle: Text('Schedule a session for Math...'),
        ),
        ListTile(
          leading: Icon(Icons.message),
          title: Text('Message from Tutor B'),
          subtitle: Text('Assignment feedback...'),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Leave Feedback'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Send Feedback'),
        ),
      ],
    );
  }
}
