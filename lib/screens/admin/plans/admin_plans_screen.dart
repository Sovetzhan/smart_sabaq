import 'package:flutter/material.dart';

class AdminPlansScreen extends StatelessWidget {
  final String schoolId;

  const AdminPlansScreen({super.key, required this.schoolId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Планы')),
      body: Center(
        child: Text('schoolId: $schoolId'),
      ),
    );
  }
}
