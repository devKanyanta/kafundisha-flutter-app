import 'package:flutter/material.dart';
import 'package:kafundisha/colors.dart';
import 'package:kafundisha/models/subtopic.dart';
import 'package:kafundisha/utils/services.dart';
import 'package:kafundisha/views/lesson.dart';

class SubTopicsScreen extends StatefulWidget {
  final String topicId;

  const SubTopicsScreen({Key? key, required this.topicId}) : super(key: key);

  @override
  _SubTopicsScreenState createState() => _SubTopicsScreenState();
}

class _SubTopicsScreenState extends State<SubTopicsScreen> {
  late Future<List<Subtopic>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = Services().fetchSubtopics(widget.topicId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sub Topics',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16
          ),
        ),
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        backgroundColor: AppColors.darkBackground,
      ),
      body: FutureBuilder<List<Subtopic>>(
        future: _topicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No subtopics available'));
          } else {
            final topics = snapshot.data!;
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> Lesson(subTopicId: topics[index].id,)));
                  },
                  child: ListTile(
                    title: Text(topics[index].name), // Ensure 'name' is a field in your Topic model
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
