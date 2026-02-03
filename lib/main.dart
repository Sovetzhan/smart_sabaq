import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'services/auth_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/teachers/teachers_screen.dart';

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
      home: const AuthGate(),
    );
  }
}

///
/// AuthGate — точка входа в приложение
/// решает: логин или основной экран
///
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        // Firebase думает
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Не залогинен
        if (!snapshot.hasData) {
          return LoginScreen();
        }

        // Залогинен → грузим профиль
        return FutureBuilder<Map<String, dynamic>>(
          future: authService.getUserProfile(snapshot.data!.uid),
          builder: (context, userSnap) {
            if (!userSnap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = userSnap.data!['role'];

            // MVP: пока только админ
            if (role == 'admin') {
              return TeachersScreen();
            }

            // Заглушка для teacher (позже сделаем TeacherApp)
            return const Scaffold(
              body: Center(
                child: Text(
                  'Teacher App пока не реализован',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
