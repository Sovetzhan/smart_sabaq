import 'package:flutter/material.dart';

class AdminTeachersScreen extends StatelessWidget {
  final String schoolId;

  const AdminTeachersScreen({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Штат')),
      body: Center(
        child: Text('schoolId: $schoolId'),
      ),
    );
  }
}
