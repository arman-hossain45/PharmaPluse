import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'medicines';

  // CREATE - পুরানো (শুধু নাম + প্রাইস)
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

  // CREATE - নতুন (নাম + প্রাইস + স্টক)
  Future<void> addMedicineWithStock(String name, String price, int stock) async {
    try {
      await _firestore.collection(_collection).add({
        'name': name,
        'price': price,
        'stock': stock,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // READ - রিয়েল-টাইম স্ট্রিম
  Stream<QuerySnapshot> getMedicines() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // UPDATE - নাম + প্রাইস (স্টক আপডেট করতে চাইলে এটাও ব্যবহার করুন)
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

  // UPDATE - নাম + প্রাইস + স্টক (যদি স্টক এডিট করতে চান)
  Future<void> updateMedicineWithStock(String docId, String name, String price, int stock) async {
    try {
      await _firestore.collection(_collection).doc(docId).update({
        'name': name,
        'price': price,
        'stock': stock,
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