import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kafundisha/models/signInUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Firebase{
  final firestore = FirebaseFirestore.instance;
  final databaseRef = FirebaseDatabase.instance.ref();


  Future<String?> getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  Future<SignUpResult> SignUpUser(String email, String password, String name) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message = '';
    String? uid;
    List<String> courses = [];

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      uid = userCredential.user?.uid;
      message = 'Sign up successful';
      prefs.setString("uid", uid.toString());
      await addStudentData(uid!, name, email, courses, 0, '');
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

  Future<SignUpResult> SignIn(
      email,
      password
      ) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String message = '';
    String? uid;

    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      uid = userCredential.user?.uid;
      message = 'Sign in successful';
      prefs.setString("uid", uid.toString());
    } on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found') {
        message = 'Please check your credentials';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
    }

    String userId = auth.currentUser!.uid;

    prefs.setString('uid', userId);
    return SignUpResult(message, userId);
  }

  Future<void> addStudentData(String uid, String name, String email, List<String> courses, int age, String gender) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('students').doc(uid).set({
        'name': name,
        'email': email,
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

}