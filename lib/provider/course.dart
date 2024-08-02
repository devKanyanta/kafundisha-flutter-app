import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kafundisha/models/course.dart';
import 'package:kafundisha/models/topic.dart';
import 'package:kafundisha/models/subtopic.dart';
import 'package:kafundisha/models/lesson.dart';
import 'package:kafundisha/utils/firebase.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];
  List<Topic> _topics = [];
  List<Subtopic> _subtopics = [];
  List<LessonModel> _lessons = [];

  final FirebaseFunctions _dataService = FirebaseFunctions();

  List<Course> get courses => _courses;
  List<Topic> get topics => _topics;
  List<Subtopic> get subtopics => _subtopics;
  List<LessonModel> get lessons => _lessons;

  Future<void> loadCourses() async {
    _courses = await _dataService.fetchCourses();
    notifyListeners();
  }

  Future<void> loadTopics(String courseId) async {
    _topics = await _dataService.fetchTopics(courseId);
    notifyListeners();
  }

  Future<void> loadSubtopics(String topicId) async {
    _subtopics = await _dataService.fetchSubtopics(topicId);
    notifyListeners();
  }

  Future<void> loadLessons(String subtopicId) async {
    _lessons = await _dataService.fetchLessons(subtopicId);
    notifyListeners();
  }

  void setCourses(List<Course> courses) {
    _courses = courses;
    notifyListeners();
  }

  void addCourse(Course course) {
    _courses.add(course);
    notifyListeners();
  }

  void updateCourse(Course updatedCourse) {
    int index = _courses.indexWhere((course) => course.id == updatedCourse.id);
    if (index != -1) {
      _courses[index] = updatedCourse;
      notifyListeners();
    }
  }

  void removeCourse(String courseId) {
    _courses.removeWhere((course) => course.id == courseId);
    notifyListeners();
  }

  void setTopics(List<Topic> topics) {
    _topics = topics;
    notifyListeners();
  }

  void addTopic(Topic topic) {
    _topics.add(topic);
    notifyListeners();
  }

  void updateTopic(Topic updatedTopic) {
    int index = _topics.indexWhere((topic) => topic.id == updatedTopic.id);
    if (index != -1) {
      _topics[index] = updatedTopic;
      notifyListeners();
    }
  }

  void removeTopic(String topicId) {
    _topics.removeWhere((topic) => topic.id == topicId);
    notifyListeners();
  }

  void setSubtopics(List<Subtopic> subtopics) {
    _subtopics = subtopics;
    notifyListeners();
  }

  void addSubtopic(Subtopic subtopic) {
    _subtopics.add(subtopic);
    notifyListeners();
  }

  void updateSubtopic(Subtopic updatedSubtopic) {
    int index = _subtopics.indexWhere((subtopic) => subtopic.id == updatedSubtopic.id);
    if (index != -1) {
      _subtopics[index] = updatedSubtopic;
      notifyListeners();
    }
  }

  void removeSubtopic(String subtopicId) {
    _subtopics.removeWhere((subtopic) => subtopic.id == subtopicId);
    notifyListeners();
  }

  void setLessons(List<LessonModel> lessons) {
    _lessons = lessons;
    notifyListeners();
  }

  void addLesson(LessonModel lesson) {
    _lessons.add(lesson);
    notifyListeners();
  }

  void updateLesson(LessonModel updatedLesson) {
    int index = _lessons.indexWhere((lesson) => lesson.id == updatedLesson.id);
    if (index != -1) {
      _lessons[index] = updatedLesson;
      notifyListeners();
    }
  }

  void removeLesson(String lessonId) {
    _lessons.removeWhere((lesson) => lesson.id == lessonId);
    notifyListeners();
  }
}
