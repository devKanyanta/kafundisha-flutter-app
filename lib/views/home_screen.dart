import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kafundisha/colors.dart';
import 'package:kafundisha/modalViews/course_search.dart';
import 'package:kafundisha/models/student.dart';
import 'package:kafundisha/provider/course.dart';
import 'package:kafundisha/provider/student.dart';
import 'package:kafundisha/utils/firebase.dart';
import 'package:kafundisha/views/topics.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<void> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = Provider.of<CourseProvider>(context, listen: false).loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    Student? student = Provider.of<StudentProvider>(context).student;

    if (student == null) {
      return const Scaffold(
        body: Center(
          child: Text('No student data available'),
        ),
      );
    }

    List<String> splitName = student.name.split(' ');

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(student.profileUrl),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkBackground.withAlpha(180),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: AppColors.darkBackground,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome ${splitName[0] ?? ' '}',
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const Text(
                                'Explore and Discover',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                                    ),
                                    builder: (BuildContext context) {
                                      return SearchModal();
                                    },
                                  );
                                },
                                child: TextField(
                                  style: const TextStyle(color: Colors.white),
                                  enabled: false,
                                  decoration: InputDecoration(
                                    hintText: 'Search courses',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(width: 2.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Colors.blue,
                                        width: 2.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildCategoryButton('Math', Icons.calculate),
                              _buildCategoryButton('Science', Icons.science),
                              _buildCategoryButton('Code', Icons.code),
                              _buildCategoryButton('Social', Icons.people),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Popular Courses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            FutureBuilder(
              future: _coursesFuture,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('An error occurred!'));
                } else {
                  return Consumer<CourseProvider>(
                    builder: (ctx, courseProvider, child) {
                      var courses = courseProvider.courses;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      course.name,
                                      style: const TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      course.description,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(12)),
                                        color: AppColors.lightBackground,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star_half_sharp,
                                            color: AppColors.orange,
                                            size: 16,
                                          ),
                                          Text(
                                            course.rating.toString(),
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TopicsScreen(courseId: course.id), // Pass the course ID
                                                ),
                                              );
                                            },
                                            child: const Row(
                                              children: [
                                                Text(
                                                  'Open Course',
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                                Icon(
                                                  Icons.double_arrow_sharp,
                                                  size: 16,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCategoryButton(String label, IconData icon) {
  return Column(
    children: [
      Icon(icon, size: 38, color: Colors.white),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
    ],
  );
}
