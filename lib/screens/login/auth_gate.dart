import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

        if (!snapshot.hasData) {
          return  LoginScreen();
        }

        final firebaseUser = snapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser.uid)
              .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const Scaffold(
                body: Center(child: Text('User document not found')),
              );
            }

            final data = userSnapshot.data!.data() as Map<String, dynamic>;

            final userContext = UserContext(
              userId: firebaseUser.uid,
              schoolId: data['schoolId'],
              role: data['role'] == 'admin'
                  ? UserRole.admin
                  : UserRole.teacher,
            );

            CurrentUser.set(userContext);

            return TeachersScreen();
          },
        );
      },
    );
  }
}
