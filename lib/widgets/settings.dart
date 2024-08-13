import 'package:flutter/material.dart';
import 'package:kafundisha/views/upload_content.dart';

class PersonalizationSettings extends StatefulWidget {
  @override
  _PersonalizationSettingsState createState() => _PersonalizationSettingsState();
}

class _PersonalizationSettingsState extends State<PersonalizationSettings> {
  bool notificationsEnabled = true;
  String selectedLearningStyle = 'Visual';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Learning Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        DropdownButton<String>(
          value: selectedLearningStyle,
          onChanged: (newValue) {
            setState(() {
              selectedLearningStyle = newValue!;
            });
          },
          items: <String>['Visual', 'Auditory', 'Kinesthetic']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SwitchListTile(
          title: Text('Enable Notifications'),
          value: notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              notificationsEnabled = value;
            });
          },
        ),
        ListTile(
          title: Text('Change Password'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Navigate to password change screen
          },
        ),
        ListTile(
          title: Text('Add Content'),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => UploadContent()));
          },
        ),
      ],
    );
  }
}
