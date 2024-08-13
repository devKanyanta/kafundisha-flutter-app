import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kafundisha/models/lesson.dart';
import 'package:kafundisha/utils/services.dart';

class Lesson extends StatefulWidget {
  final String subTopicId;
  const Lesson({super.key, required this.subTopicId});

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  String displayText = '';
  Future<List<LessonModel>>? futureLessons;

  @override
  void initState() {
    super.initState();
    Services().generateText(widget.subTopicId).then((value){
      displayText = value;
    });
    futureLessons = Services().fetchLessons(widget.subTopicId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Markdown(
              data: displayText,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12.0),
            height: 70,
            child: Row(
              children: [
                IconButton(
                    onPressed: (){

                },
                  icon: const Icon(
                      Icons.arrow_back_ios
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: (){

                  },
                  icon: const Icon(
                      Icons.arrow_forward_ios
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
