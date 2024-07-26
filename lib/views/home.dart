import 'package:flutter/material.dart';
import 'package:kafundisha/colors.dart';
import 'package:kafundisha/models/student.dart';
import 'package:kafundisha/utils/firebase.dart';
import 'package:kafundisha/views/courses.dart';
import 'package:kafundisha/views/home_screen.dart';
import 'package:kafundisha/views/profile.dart';
import 'package:kafundisha/views/progress.dart';
import 'package:provider/provider.dart';
import 'package:kafundisha/provider/student.dart'; // Import the StudentProvider class

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({super.key, required this.uid});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Future<void>? _fetchStudentData;

  @override
  void initState() {
    super.initState();
    print(widget.uid);
    _fetchStudentData = _initializeStudentData();
  }

  Future<void> _initializeStudentData() async {
    final firebaseService = FirebaseFunctions();
    Student? student = await firebaseService.getUserData(widget.uid);
    if (student != null) {
      Provider.of<StudentProvider>(context, listen: false).setStudent(student);
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    CourseContentScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchStudentData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: IndexedStack(
              index: _selectedIndex,
              children: _widgetOptions,
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: AppColors.lightBackground,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Courses',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up),
                  label: 'Progress',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: AppColors.orange,
              unselectedItemColor: AppColors.darkBackground,
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}
