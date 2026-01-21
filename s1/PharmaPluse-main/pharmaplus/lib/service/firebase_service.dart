import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'medicines';

  // 🔥 ADD MEDICINE (NO IMAGE)
  Future<void> addFullMedicine({
    required String name,
    required String category,
    required String description,
    required double price,
    required double rating,
    required int reviews,
    required int stock,
  }) async {
    await _firestore.collection(_collection).add({
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'rating': rating,
      'reviews': reviews,
      'stock': stock,
      'inStock': stock > 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔥 READ
  Stream<QuerySnapshot> getMedicines() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // 🔥 DELETE
  Future<void> deleteMedicine(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
