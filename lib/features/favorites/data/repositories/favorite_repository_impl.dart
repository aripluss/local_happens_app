import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:local_happens/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/data/models/event_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  FavoriteRepositoryImpl({required this.firestore, required this.firebaseAuth});

  String get _userId {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    return user.uid;
  }

  CollectionReference<Map<String, dynamic>> get _favoritesCollection =>
      firestore.collection('users').doc(_userId).collection('favorites');

  @override
  Future<List<Event>> getFavorites() async {
    final favoritesSnapshot = await _favoritesCollection
        .orderBy('createdAt', descending: true)
        .get();

    final favoriteIds = favoritesSnapshot.docs.map((doc) => doc.id).toList();
    if (favoriteIds.isEmpty) {
      return [];
    }

    final eventsById = <String, Event>{};
    const chunkSize = 10;

    for (var index = 0; index < favoriteIds.length; index += chunkSize) {
      final chunk = favoriteIds.skip(index).take(chunkSize).toList();
      final eventsSnapshot = await firestore
          .collection('events')
          .where(FieldPath.documentId, whereIn: chunk)
          .where('status', isEqualTo: 'approved')
          .get();

      for (final doc in eventsSnapshot.docs) {
        final event = EventModel.fromFirestore(doc).toEntity();
        eventsById[event.id] = event;
      }
    }

    return favoriteIds
        .where(eventsById.containsKey)
        .map((id) => eventsById[id]!)
        .toList();
  }

  @override
  Future<bool> isFavorite(String eventId) async {
    final favoriteDoc = await _favoritesCollection.doc(eventId).get();
    return favoriteDoc.exists;
  }

  @override
  Future<void> addFavorite(String eventId) async {
    await _favoritesCollection.doc(eventId).set({
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeFavorite(String eventId) async {
    await _favoritesCollection.doc(eventId).delete();
  }
}
