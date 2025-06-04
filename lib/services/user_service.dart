import '../models/user_model.dart';

class UserService {
  // CHANGE: Rename method and add username parameter
  Future<UserModel> fetchUserInfoForUsername(String username) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // ADD: Username-based user data (mock implementation)
    if (username == 'jsmith') {
      return UserModel(
        id: 'user_jsmith',
        name: 'John Smith',
        profileImagePath: 'assets/images/profile.png',
      );
    } else {
      // Return original default data for other users
      return UserModel(
        id: 'user_${username}',
        name: username,  // Use username as display name
        profileImagePath: 'assets/images/profile.png',
      );
    }
  }

  // ADD: Method to get user by credentials (if needed)
  Future<UserModel?> getUserByCredentials(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock validation - in real app, this would check against database
    if ((username == 'jsmith' && password == 'phrpassword') ||
        (username.isNotEmpty && password.length >= 8)) {
      return fetchUserInfoForUsername(username);
    }

    return null;
  }
}