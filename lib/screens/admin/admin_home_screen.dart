import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int index = 0;

  final screens = const [
    Center(child: Text('PLANS')),
    Center(child: Text('CLASSES')),
    Center(child: Text('TEACHERS')),
    Center(child: Text('SCHEDULE')),
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
