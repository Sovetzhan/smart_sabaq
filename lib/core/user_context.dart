import 'user_role.dart';

class UserContext {
  final String userId;
  final String schoolId;
  final UserRole role;

  UserContext({
    required this.userId,
    required this.schoolId,
    required this.role,

  });
}
