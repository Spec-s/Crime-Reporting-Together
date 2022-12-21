class UserModel {
  String? userId;
  String? email;
  String? postId;

  UserModel({this.userId, this.email, this.postId});

  // getting data from the server

  factory UserModel.fromMap(map) {
    return UserModel(
      userId: map['userId'],
      email: map['email'],
      postId: map['postId'],
    );
  }

  // sending data to the server

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'postId': postId,
    };
  }
}
