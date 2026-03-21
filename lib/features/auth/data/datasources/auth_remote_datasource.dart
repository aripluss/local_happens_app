import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_happens/core/errors/exceptions.dart';
import 'package:local_happens/features/auth/domain/entities/user_role.dart';

import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> signOut();
  Future<UserModel> signInWithGoogle();
  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthRemoteDatasourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn,
       _firestore = firestore {
    _googleSignIn.initialize().catchError(
      (e) => throw AuthException('GoogleSignIn init error: $e'),
    );
  }

  Future<UserModel?> _getUserFromFirestore(String uid) async {
    final user = await _firestore.collection('users').doc(uid).get();
    if (user.exists && user.data() != null) {
      return UserModel.fromJson(user.data()!);
    }
    return null;
  }

  @override
  Stream<UserModel?> get authStateChanges =>
      _firebaseAuth.authStateChanges().asyncMap((user) async {
        if (user == null) return null;
        return await _getUserFromFirestore(user.uid);
      });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userModel = await _getUserFromFirestore(userCredential.user!.uid);
      if (userModel == null) {
        throw AuthException('Дані користувача не знайдено в базі даних');
      }
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromException(e);
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      await user.updateDisplayName(name);

      final userModel = UserModel(
        id: user.uid,
        email: email,
        name: name,
        avatarUrl: '',
        role: UserRole.user,
        createdAt: user.metadata.creationTime ?? DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromException(e);
    }
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

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user!;

      var userModel = await _getUserFromFirestore(user.uid);
      if (userModel == null) {
        userModel = UserModel(
          id: user.uid,
          email: user.email!,
          name: user.displayName!,
          avatarUrl: user.photoURL ?? '',
          role: UserRole.user,
          createdAt: user.metadata.creationTime ?? DateTime.now(),
        );
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson());
      }
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
