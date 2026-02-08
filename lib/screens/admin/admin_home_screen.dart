import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'plans/admin_plans_screen.dart';
import '../classes/classes_screen.dart';
import 'teachers/admin_teachers_screen.dart';
import 'admin_schedule_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final schoolId =
        (snapshot.data!.data() as Map<String, dynamic>)['schoolId'];

        return _AdminHomeContent(schoolId: schoolId);
      },
    );
  }
}

class _AdminHomeContent extends StatefulWidget {
  final String schoolId;

  const _AdminHomeContent({required this.schoolId});

  @override
  State<_AdminHomeContent> createState() => _AdminHomeContentState();
}

class _AdminHomeContentState extends State<_AdminHomeContent> {
  int index = 0;

  late final screens = [
    AdminPlansScreen(schoolId: widget.schoolId),
    ClassesScreen(schoolId: widget.schoolId),
    AdminTeachersScreen(schoolId: widget.schoolId),
    AdminScheduleScreen(schoolId: widget.schoolId),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.article), label: 'Планы'),
          NavigationDestination(icon: Icon(Icons.class_), label: 'Классы'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Штат'),
          NavigationDestination(icon: Icon(Icons.schedule), label: 'Расписание'),
        ],
      ),
    );
  }
}
