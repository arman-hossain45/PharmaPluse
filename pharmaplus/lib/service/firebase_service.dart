import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'medicines';

  // CREATE
  Future<void> addMedicine(String name, String price) async {
    try {
      await _firestore.collection(_collection).add({
        'name': name,
        'price': price,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // READ - stream
  Stream<QuerySnapshot> getMedicines() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // UPDATE
  Future<void> updateMedicine(String docId, String name, String price) async {
    try {
      await _firestore.collection(_collection).doc(docId).update({
        'name': name,
        'price': price,
      });
    } catch (e) {
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteMedicine(String docId) async {
    try {
      await _firestore.collection(_collection).doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
