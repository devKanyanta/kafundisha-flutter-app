import 'package:flutter/material.dart';
import 'package:kafundisha/widgets/basic_info.dart';
import 'package:kafundisha/widgets/education_info.dart';
import 'package:kafundisha/widgets/interact_tutors.dart';
import 'package:kafundisha/widgets/learning_resources.dart';
import 'package:kafundisha/widgets/settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BasicInformation(),
            SizedBox(height: 20),
            EducationalInformation(),
            // SizedBox(height: 20),
            // InteractionWithTutors(),
            // SizedBox(height: 20),
            // LearningResources(),
            SizedBox(height: 20),
            PersonalizationSettings(),
          ],
        ),
      ),
    );
  }
}
