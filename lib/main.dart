import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kafundisha/provider/course.dart';
import 'package:kafundisha/provider/student.dart';
import 'package:kafundisha/utils/services.dart';
import 'package:kafundisha/views/home.dart';
import 'package:provider/provider.dart';
import 'views/sign_up.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Gemini.init(apiKey: 'AIzaSyDAzeuec2Hv9jjC47gRpl7pEcIqeu0xS0');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String uid = '';
  bool loading = true;

  Future<void> fetchUserId() async {
    uid = await Services().getUserId();
  }

  @override
  Widget build(BuildContext context) {
    fetchUserId().then((value){
      setState(() {
        loading = false;
      });
    });
    if (uid.isNotEmpty) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(uid: uid!),
      );
    } else if(uid == '0'){
      return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const SignUp(),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}