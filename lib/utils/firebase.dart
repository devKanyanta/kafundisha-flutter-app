import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kafundisha/models/signInUp.dart';
import 'package:kafundisha/models/student.dart';
import 'package:kafundisha/provider/student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirebaseFunctions {
  final firestore = FirebaseFirestore.instance;
  final databaseRef = FirebaseDatabase.instance.ref();

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("uid") ?? '';
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
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      uid = userCredential.user?.uid;
      message = 'Sign up successful';
      prefs.setString("uid", uid.toString());
      await addStudentData(uid!, name, email, courses, 0, '', 'https://ui-avatars.com/api/?name=$name');

      Student student = Student(uid: uid, name: name, email: email, courses: courses, age: 0, gender: '', profileUrl: 'https://ui-avatars.com/api/?name=$name', createdAt: DateTime.now());
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

  Future<void> addStudentData(String uid, String name, String email, List<String> courses, int age, String gender, String profileUrl) async {
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
}
