import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:kafundisha/models/lesson.dart';
import 'package:kafundisha/utils/firebase.dart';

class Lesson extends StatefulWidget {
  final String subTopicId;
  const Lesson({super.key, required this.subTopicId});

  @override
  State<Lesson> createState() => _LessonState();
}

class _LessonState extends State<Lesson> {
  String displayText = '';
  final model = GenerativeModel(model: "gemini-1.5-flash", apiKey: 'AIzaSyDAzeuec2Hv9jjC47gRpl7pEcIqeu0xS0A');
  Future<List<LessonModel>>? futureLessons;
  final FirebaseFunctions ttsService = FirebaseFunctions();

  @override
  void initState() {
    super.initState();
    generateText();
    futureLessons = FirebaseFunctions().fetchLessons(widget.subTopicId);
  }

  void generateText() async {
    setState(() {
      displayText = '';
    });

    try {
      List<LessonModel> lessons = await FirebaseFunctions().fetchLessons(widget.subTopicId);
      String lessonTitles = lessons.map((lesson) => lesson.title).join(", ");

      final response = await model.generateContent([
        Content.text("Write an introduction for the following lessons: $lessonTitles"),
      ]);

      ttsService.textToSpeech(response.text.toString());

      setState(() {
        displayText = response.text.toString();
      });
    } catch (e) {
      print("Error generating text: $e");
      setState(() {
        displayText = 'Error generating text';
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Markdown(
          data: displayText
        ),
      ),
    );
  }
}
