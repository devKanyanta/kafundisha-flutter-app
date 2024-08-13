import 'package:flutter/material.dart';
import 'package:kafundisha/colors.dart';
import 'package:kafundisha/models/topic.dart';
import 'package:kafundisha/utils/services.dart';
import 'package:kafundisha/views/sub_topics.dart';

class TopicsScreen extends StatefulWidget {
  final String courseId; // Course ID to fetch topics

  const TopicsScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late Future<List<Topic>> _topicsFuture;

  @override
  void initState() {
    super.initState();
    _topicsFuture = Services().fetchTopics(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        backgroundColor: AppColors.darkBackground,
        title: const Text(
            'Topics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16
          ),
        ),
      ),
      body: FutureBuilder<List<Topic>>(
        future: _topicsFuture,
        builder: (context, Services) {
          if (Services.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (Services.hasError) {
            return Center(child: Text('Error: ${Services.error}'));
          } else if (!Services.hasData || Services.data!.isEmpty) {
            return const Center(child: Text('No topics available'));
          } else {
            final topics = Services.data!;
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SubTopicsScreen(topicId: topics[index].id,)));
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
