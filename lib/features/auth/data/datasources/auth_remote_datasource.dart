import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_happens/core/errors/exceptions.dart';

import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> signOut();
  Future<UserModel> signInWithGoogle();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDatasourceImpl({
    required this.firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _googleSignIn = googleSignIn {
    _googleSignIn.initialize().catchError(
      (e) => throw AuthException('GoogleSignIn init error: $e'),
    );
  }

  UserModel _mapFirebaseUserToModel(User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'No name',
      createdAt: user.metadata.creationTime ?? DateTime.now(),
    );
  }

  @override
  Stream<UserModel?> get authStateChanges => firebaseAuth
      .authStateChanges()
      .map((user) => user != null ? _mapFirebaseUserToModel(user) : null);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUserToModel(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromException(e);
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      return _mapFirebaseUserToModel(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromException(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    return user != null ? _mapFirebaseUserToModel(user) : null;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.authenticate();

      final clientAuth = await googleUser.authorizationClient.authorizeScopes([
        'email',
        'profile',
      ]);

      final credential = GoogleAuthProvider.credential(
        accessToken: clientAuth.accessToken,
        idToken: googleUser.authentication.idToken,
      );

      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      return _mapFirebaseUserToModel(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<void> signOut() {
    return firebaseAuth.signOut();
  }
}
