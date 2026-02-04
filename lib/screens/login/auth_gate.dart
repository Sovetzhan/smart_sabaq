import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/current_user.dart';
import '../../core/user_context.dart';
import '../../core/user_role.dart';
import '../teachers/teachers_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final firebaseUser = snapshot.data!;

          // ⚠️ ВРЕМЕННО. ТОЛЬКО ЧТОБЫ ПРИЛОЖЕНИЕ ЖИЛО
          CurrentUser.user = UserContext(
            userId: firebaseUser.uid,
            schoolId: 'school_001', // ← тот самый ID школы
            role: UserRole.admin,   // ← пока жёстко
          );

          return TeachersScreen();
        }


        // НЕ ЗАЛОГИНЕН
        return LoginScreen();
      },
    );
  }
}
