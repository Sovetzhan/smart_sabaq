import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_sabaq/screens/login/auth_gate.dart';

import 'firebase_options.dart';

import 'services/lesson_plan_service.dart';


Future<void> testGetLessonPlan() async {
  final result = await LessonPlanService().getByScheduleAndDate(
    schoolId: 'school-uuid-1',
    scheduleItemId: 'schedule-item-uuid-1',
    lessonDate: DateTime(2026, 2, 4),
  );

  if (result == null) {
    debugPrint('LESSON PLAN NOT FOUND');
  } else {
    debugPrint('LESSON PLAN FOUND: ${result.topic}');
  }
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // ТЕСТ. МОЖНО ВКЛЮЧАТЬ И ВЫКЛЮЧАТЬ
  // await testGetLessonPlan();

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
      home: const AuthGate(),


    );
  }
}
