import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/teachers/teachers_screen.dart';

// ⚠️ временно. потом будет из авторизации
//const String schoolId = 'school_001';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: TeachersScreen(),
    );
  }
}
