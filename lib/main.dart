import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/teachers/teachers_screen.dart';

// ⚠️ временно. потом будет из авторизации
//const String schoolId = 'school_001';

import 'services/lesson_plan_service.dart';

Future<void> testGetLessonPlan() async {
  final result = await LessonPlanService().getByScheduleAndDate(
    schoolId: 'school_001',          // ТВОЙ schoolId
    scheduleItemId: 'SCHEDULE_1',    // ТВОЙ scheduleItemId
    date: '2026-02-04',
  );


  if (result == null) {
    print('LESSON PLAN NOT FOUND');
  } else {
    print('LESSON PLAN FOUND: ${result.topic}');
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await testGetLessonPlan(); // ← ВОТ ЭТО ВАЖНО
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
