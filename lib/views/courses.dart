import 'package:flutter/material.dart';
import 'package:kafundisha/colors.dart';
import 'package:kafundisha/views/topics.dart';

class CourseContentScreen extends StatelessWidget {
  final List<Map<String, dynamic>> courseContent = [
    {
      "title": "Mathematics",
      "topics": "10 topics",
      "description": "Different levels e.g high school & college math",
      "rating": 4.5,
    },
    {
      "title": "Physics",
      "topics": "10 topics",
      "description": "Different levels e.g high school & college math",
      "rating": 4.5,
    },
    {
      "title": "Mathematics",
      "topics": "10 topics",
      "description": "Different levels e.g high school & college math",
      "rating": 4.5,
    },
    {
      "title": "Mathematics",
      "topics": "10 topics",
      "description": "Different levels e.g high school & college math",
      "rating": 4.5,
    },
    {
      "title": "Physics",
      "topics": "10 topics",
      "description": "Different levels e.g high school & college math",
      "rating": 4.5,
    },
    {
      "title": "Mathematics",
      "topics": "10 topics",
      "description": "Different levels e.g high school & college math",
      "rating": 4.5,
    },
  ];

  final List<Map<String, dynamic>> dummyTopics = [
    {
      "title": "Introduction to Mathematics",
      "description": "An introduction to basic mathematical concepts.",
    },
    {
      "title": "Advanced Algebra",
      "description": "A deep dive into advanced algebraic techniques.",
    },
    {
      "title": "Geometry",
      "description": "Understanding shapes, sizes, and the properties of space.",
    },
    {
      "title": "Calculus",
      "description": "An exploration of limits, derivatives, and integrals.",
    },
    {
      "title": "Statistics",
      "description": "Analyzing data, probability, and statistical methods.",
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
          automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: courseContent.length,
        itemBuilder: (context, index) {
          final course = courseContent[index];
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
                        course['title'],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        course['topics'],
                        style: const TextStyle(
                            fontSize: 14
                        ),
                      ),
                      Text(
                        course['description'],
                        style: const TextStyle(
                            fontSize: 14
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: AppColors.lightBackground
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_half_sharp,
                              color: AppColors.orange,
                              size: 16,
                            ),
                            Text(
                              course['rating'].toString(),
                              style: const TextStyle(
                                  fontSize: 12
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>TopicsScreen(topics: dummyTopics)));
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    'Open Course',
                                    style: TextStyle(
                                        fontSize: 12
                                    ),
                                  ),
                                  Icon(
                                    Icons.double_arrow_sharp,
                                    size: 16,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
            ),
          );
        },
      ),
    );
  }
}
