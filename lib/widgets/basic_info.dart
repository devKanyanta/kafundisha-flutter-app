import 'package:flutter/material.dart';
import 'package:kafundisha/colors.dart';
import 'package:kafundisha/models/student.dart';
import 'package:kafundisha/provider/student.dart';
import 'package:provider/provider.dart';

class BasicInformation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Student? student = Provider.of<StudentProvider>(context).student;
    if (student == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(student.profileUrl),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.name,
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.darkBackground.withAlpha(180)
              ),
            ),
            Text(
              student.email,
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.darkBackground
              ),
            ),
          ],
        )
      ],
    );
  }
}
