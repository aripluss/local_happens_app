import 'package:firebase_auth/firebase_auth.dart';

class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Error']);
}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication Error']);
  factory AuthException.fromException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'user-not-found':
        return AuthException('User not found');
      case 'wrong-password':
        return AuthException('Wrong password');
      case 'email-already-in-use':
        return AuthException('Email already in use');
      case 'invalid-email':
        return AuthException('Invalid email');
      case 'weak-password':
        return AuthException('Weak password');
      case 'user-disabled':
        return AuthException('User disabled');
      case 'account-exists-with-different-credential':
        return AuthException('Account exists with different credential');
      default:
        return AuthException('Authentication error: ${exception.toString()}');
    }
  }
}
