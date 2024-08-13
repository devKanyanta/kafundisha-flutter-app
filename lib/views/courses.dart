import 'package:flutter/material.dart';
import 'package:kafundisha/colors.dart';
import 'package:kafundisha/provider/course.dart';
import 'package:kafundisha/views/topics.dart';
import 'package:provider/provider.dart';

class CourseContentScreen extends StatefulWidget {
  const CourseContentScreen({super.key});

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  late Future<void> courses;

  bool isLoading = true;

  void fetch() async {
    courses = Provider.of<CourseProvider>(context, listen: false).loadCourses();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetch();
    return isLoading ? const Center(child: CircularProgressIndicator()) : Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: courses,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('An error occurred!'));
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
                                      // Text(
                                      //   course.rating.toString(),
                                      //   style: const TextStyle(fontSize: 12),
                                      // ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TopicsScreen(courseId: course.id),
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
      ),
    );
  }
}

