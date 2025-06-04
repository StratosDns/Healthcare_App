import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';
import '../user_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  String? _loggedInUsername; // ADD: logged in username

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;

  final UserService _userService = UserService();

  // ADD: method to set logged in user
  void setLoggedInUser(String username) {
    _loggedInUsername = username;
    fetchUserInfo(); // Fetch user info when username is set
  }

  Future<void> fetchUserInfo() async {
    if (_loggedInUsername == null) return; // ADD: check for username

    try {
      _isLoading = true;
      notifyListeners();

      // CHANGE: Fetch user info for specific username
      _currentUser = await _userService.fetchUserInfoForUsername(_loggedInUsername!);
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}