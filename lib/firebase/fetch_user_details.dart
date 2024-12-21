import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> fetchUser(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return User.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  Future<void> updateUser(String userId, User user) async {
    try {
      await _firestore.collection('users').doc(userId).update(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}