import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/io_client.dart';
import 'package:kafundisha/models/course.dart';
import 'package:kafundisha/models/lesson.dart';
import 'package:kafundisha/models/signInUp.dart';
import 'package:kafundisha/models/student.dart';
import 'package:kafundisha/models/subtopic.dart';
import 'package:kafundisha/models/topic.dart';
import 'package:kafundisha/provider/student.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class Services {
  final firestore = FirebaseFirestore.instance;
  final databaseRef = FirebaseDatabase.instance.ref();
  final String apiKey = 'e67c9538ec8ffa6e46b90eea9bd06952';
  final String apiUrl = 'https://api.elevenlabs.io/v1/text-to-speech/en_us_male/stream';
  final String xiApiKey = 'e67c9538ec8ffa6e46b90eea9bd06952';
  final String voiceId = '21m00Tcm4TlvDq8ikWAM';
  final String ttsUrl = 'https://api.elevenlabs.io/v1/text-to-speech/<voice-id>/stream';
  final player = AudioPlayer();
  final model = GenerativeModel(model: "gemini-1.5-flash", apiKey: 'AIzaSyDAzeuec2Hv9jjC47gRpl7pEcIqeu0xS0A');

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("uid") ?? '0';
  }

  Future<void> clearAppData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Provider.of<StudentProvider>(context, listen: false).clearStudent();
  }

  Future<SignUpResult> signUpUser(
      String email, String password, String name, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message = '';
    String? uid;
    List<String> courses = [];
    print('Signing up');

    try {
      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      uid = userCredential.user?.uid;
      message = 'Sign up successful';
      prefs.setString("uid", uid.toString());
      await addStudentData(uid!, name, email, courses, 0, '',
          'https://ui-avatars.com/api/?name=$name');

      Student student = Student(
          uid: uid,
          name: name,
          email: email,
          courses: courses,
          age: 0,
          gender: '',
          profileUrl: 'https://ui-avatars.com/api/?name=$name',
          createdAt: DateTime.now());
      Provider.of<StudentProvider>(context, listen: false).setStudent(student);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          message = 'Cannot sign in with weak password';
          break;
        case 'email-already-in-use':
          message = 'Email is in use by another user';
          break;
        case 'wrong-password':
          message = 'Wrong password provided';
          break;
        default:
          message = 'Please check your credentials';
          break;
      }
    }

    return SignUpResult(message, uid);
  }

  Future<SignUpResult> signIn(
      String email, String password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message = '';
    String? uid;

    try {
      UserCredential userCredential =
      await auth.signInWithEmailAndPassword(email: email, password: password);
      uid = userCredential.user?.uid;
      message = 'Sign in successful';
      prefs.setString("uid", uid.toString());

      Student? student = await getUserData(uid!);
      if (student != null) {
        Provider.of<StudentProvider>(context, listen: false).setStudent(student);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'Please check your credentials';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
    }

    return SignUpResult(message, uid);
  }

  Future<void> addStudentData(String uid, String name, String email,
      List<String> courses, int age, String gender, String profileUrl) async {
    try {
      await firestore.collection('students').doc(uid).set({
        'name': name,
        'email': email,
        'profileUrl': profileUrl,
        'courses': courses,
        'age': age,
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Student data added successfully');
    } catch (e) {
      print('Failed to add student data: $e');
    }
  }

  Future<Student?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection('students').doc(uid).get();

      if (doc.exists) {
        print('User data retrieved successfully');
        return Student.fromMap(uid, doc.data() as Map<String, dynamic>);
      } else {
        print('No such document!');
        return null;
      }
    } catch (e) {
      print('Failed to retrieve user data: $e');
      return null;
    }
  }

  Future<List<Course>> fetchCourses() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('courses').get();
      return querySnapshot.docs.map((doc) {
        return Course(
          id: doc.id,
          name: doc['name'],
          description: doc['description'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching courses: $e");
      return [];
    }
  }

  Future<List<Topic>> fetchTopics(String courseId) async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('topics')
          .where('courseId', isEqualTo: courseId).get();
      return querySnapshot.docs.map((doc) {
        return Topic(
          id: doc.id,
          name: doc['title'],
          index: doc['index'],
          courseId: doc['courseId'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching topics: $e");
      return [];
    }
  }

  Future<List<Subtopic>> fetchSubtopics(String topicId) async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('subtopics')
          .where('topicId', isEqualTo: topicId).get();
      return querySnapshot.docs.map((doc) {
        return Subtopic(
          id: doc.id,
          name: doc['title'],
          index: doc['index'],
          topicId: doc['topicId'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching subtopics: $e");
      return [];
    }
  }

  Future<List<LessonModel>> fetchLessons(String subtopicId) async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('lessons')
          .where('subtopicId', isEqualTo: subtopicId).get();
      return querySnapshot.docs.map((doc) {
        return LessonModel(
          id: doc.id,
          name: doc['title'],
          index: doc['index'],
          description: doc['description'],
          subtopicId: doc['subtopicId'],
        );
      }).toList();
    } catch (e) {
      print("Error fetching lessons: $e");
      return [];
    }
  }


  String replaceNonLetters(String input) {
    // Define regular expressions for common Markdown symbols
    final regex = RegExp(r'(\*\*|__|[_*~`>#\[\]()\-\+]+|(?:\d+\.))');

    // Replace matched Markdown symbols with an empty string
    return input.replaceAll(regex, '');
  }

  Future<void> textToSpeech(String text) async {
    String newText = replaceNonLetters(text);
    String voiceRachel = 'BtWabtumIemAotTjP5sk'; // Ensure this voice ID is correct
    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceRachel';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Accept': 'audio/mpeg',
          'xi-api-key': xiApiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'text': newText,
          'model_id': 'eleven_monolingual_v1',
          'voice_settings': {
            'stability': 0.15,
            'similarity_boost': 0.75,
          },
        }),
      );

      if (response.statusCode == 200) {
        final audioBytes = response.bodyBytes;
        final audioPlayer = AudioPlayer();
        await audioPlayer.play(BytesSource(audioBytes));
        print('Audio stream played successfully.');
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  Future<void> textToSpeechv2(String text) async {
    String newText = replaceNonLetters(text);

    FlutterTts flutterTts = FlutterTts();

    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);

      await flutterTts.speak(newText);

      print('Text to speech conversion started.');
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  Future<String> generateText(String subTopicId) async {

    String resBody = '';

    try {
      List<LessonModel> lessons = await Services().fetchLessons(subTopicId);
      String lessonnames = lessons.map((lesson) => lesson.name).join(", ");

      final response = await model.generateContent([
        Content.text("Write an introduction for the following lessons: $lessonnames"),
      ]);

      textToSpeechv3(response.text.toString());
      resBody = response.text.toString();
    } catch (e) {
      print("Error generating text: $e");

      resBody = "Error generating text: $e";
    }

    return resBody;
  }

  Future<void> textToSpeechv3(String text) async {
    final url = Uri.parse('https://api.v7.unrealspeech.com/stream');
    final apiKey = 'upp4fDnymJT2s936ytwFQxAJ6izHpvtRaIP3hkiQ4IPvVeMRtXC69d';

    String newText = replaceNonLetters(text);

    // Prepare the request headers and body
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'Text': newText,
      'VoiceId': 'Will',
      'Bitrate': '320k',
      'Speed': '0.1',
      'Pitch': '1',
      'Codec': 'libmp3lame',
    });

    try {
      // Use CustomHttpClient to bypass certificate validation
      final client = CustomHttpClient();
      final response = await client.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Get the application's documents directory
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/audio.mp3';

        final audioBytes = response.bodyBytes;
        final audioPlayer = AudioPlayer();
        await audioPlayer.play(BytesSource(audioBytes));

        // Save the response content as an audio file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('Audio saved to $filePath');
      } else {
        print('Failed to generate audio. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  String toSentenceCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  Future<List<Course>> searchCourses(String query) async {

    String sentenceCaseQuery = toSentenceCase(query);

    try {
      // Perform a search query in Firestore
      QuerySnapshot querySnapshot = await firestore
          .collection('courses')
          .where('name', isGreaterThanOrEqualTo: sentenceCaseQuery)
          .where('name', isLessThanOrEqualTo: sentenceCaseQuery + '\uf8ff')
          .get();

      // Map the results to a list of Course objects
      return querySnapshot.docs.map((doc) {
        return Course(
          id: doc.id,
          name: doc['name'],
          description: doc['description'],
          // Add other fields as necessary
        );
      }).toList();
    } catch (e) {
      print("Error searching for courses: $e");
      return [];
    }
  }

  // Add a course
  Future<void> addCourse(Course course) async {
    await firestore.collection('courses').doc(course.id).set(course.toMap());
    await firestore.collection('toc').doc(course.id).set({
      'topics': {},
      'subtopics': {},
    });
  }

  // Add a courses
  Future<void> addCourses(List<Course> courses) async {

    for (var course in courses) {
        await firestore.collection('courses').doc(course.id).set({
          'id': course.id,
          'name': course.name,
          'description': course.description,
        });
      }
  }

  Future<List<DropdownMenuItem<String>>> fetchCourseDropdownItems() async {
    // Fetch courses from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('courses').get();

    // Map each document to a DropdownMenuItem with course name as value
    List<DropdownMenuItem<String>> courseItems = snapshot.docs.map((doc) {
      String courseName = doc['name'];
      return DropdownMenuItem<String>(
        value: courseName, // The course name will be the value
        child: Text(courseName), // Display the course name
      );
    }).toList();

    return courseItems;
  }

  // Add a topic and update TOC
  Future<void> addTopic(Topic topic) async {
    await firestore.collection('topics').doc(topic.id).set(topic.toMap());

    DocumentSnapshot tocSnapshot = await firestore.collection('toc').doc(topic.courseId).get();
    Map<String, dynamic> tocData = tocSnapshot.data() as Map<String, dynamic>;
    Map<String, int> topics = Map<String, int>.from(tocData['topics']);

    topics[topic.id] = topic.index;
    _sortMapByIndex(topics);

    await firestore.collection('toc').doc(topic.courseId).update({
      'topics': topics,
    });
  }

  // Add a subtopic and update TOC
  Future<void> addSubtopic(Subtopic subtopic) async {
    await firestore.collection('subtopics').doc(subtopic.id).set(subtopic.toMap());

    DocumentSnapshot topicSnapshot = await firestore.collection('topics').doc(subtopic.topicId).get();
    String courseId = topicSnapshot['courseId'];

    DocumentSnapshot tocSnapshot = await firestore.collection('toc').doc(courseId).get();
    Map<String, dynamic> tocData = tocSnapshot.data() as Map<String, dynamic>;
    Map<String, int> subtopics = Map<String, int>.from(tocData['subtopics']);

    subtopics[subtopic.id] = subtopic.index;
    _sortMapByIndex(subtopics);

    await firestore.collection('toc').doc(courseId).update({
      'subtopics': subtopics,
    });
  }

  // Add a lesson
  Future<void> addLesson(LessonModel lesson) async {
    await firestore.collection('lessons').doc(lesson.id).set(lesson.toMap());
  }

  // Utility function to sort a map by its values (index)
  void _sortMapByIndex(Map<String, int> map) {
    var sortedKeys = map.keys.toList(growable: false)
      ..sort((k1, k2) => map[k1]!.compareTo(map[k2]!));
    Map<String, int> sortedMap = {for (var k in sortedKeys) k: map[k]!};
    map.clear();
    map.addAll(sortedMap);
  }

}

class CustomHttpClient extends IOClient {
  CustomHttpClient() : super(HttpClient()..badCertificateCallback = (cert, host, port) => true);
}