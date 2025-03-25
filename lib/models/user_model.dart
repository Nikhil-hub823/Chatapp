class AppUser {
  final String uid;
  final String email;

  AppUser({
    required this.uid,
    required this.email,
  });

  // Convert Firestore document to AppUser
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
    );
  }

  // Convert AppUser to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}
