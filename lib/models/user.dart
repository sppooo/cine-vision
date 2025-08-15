// lib/models/user.dart

class User {
  final String username;
  final String email;
  final String profilePhoto;

  User({required this.username, required this.email, required this.profilePhoto});

  // Add static user variable to store the logged-in user info
  static User? loggedInUser;
}
