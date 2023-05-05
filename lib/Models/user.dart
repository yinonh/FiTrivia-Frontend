class StandardUser {
  String uid;
  String email;
  bool isAdmin;
  String userName;

  StandardUser({
    required this.uid,
    required this.email,
    required this.isAdmin,
    required this.userName,
  });

  factory StandardUser.fromJson(Map<String, dynamic> json) {
    return StandardUser(
        uid: json['uid'],
        email: json['email'],
        isAdmin: json['isAdmin'],
        userName: json['userName;']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userName': userName,
      'email': email,
      'isAdmin': isAdmin,
    };
  }
}
