import 'user_context.dart';

class CurrentUser {
  static UserContext? _user;

  static void set(UserContext user) {
    _user = user;
  }

  static UserContext get require {
    if (_user == null) {
      throw Exception('CurrentUser not initialized');
    }
    return _user!;
  }

  static void clear() {
    _user = null;
  }
}
