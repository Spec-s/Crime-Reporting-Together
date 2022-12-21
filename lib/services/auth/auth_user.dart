import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

// user will be authenticated in this file
//this will not be accessible by the main UI

@immutable // means that this class cannot have any fields that change
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

// factory user is used as a copy constructor to copy itself
  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email!,
        isEmailVerified: user.emailVerified,
        id: user.uid,
      );
}
