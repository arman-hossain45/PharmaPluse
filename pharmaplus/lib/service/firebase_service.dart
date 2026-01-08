import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference _medicines = 
      FirebaseFirestore.instance.collection('medicines');

  Stream<QuerySnapshot> getMedicines() {
    return _medicines.snapshots();
  }

  // FIX: Parameter type for price must be 'num'
  Future<void> addMedicineWithStock(String name, num price, int stock) async {
    return _medicines.add({
      'name': name,
      'price': price,
      'stock': stock,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // FIX: Parameter type for price must be 'num'
  Future<void> updateMedicineWithStock(String docId, String name, num price, int stock) async {
    return _medicines.doc(docId).update({
      'name': name,
      'price': price,
      'stock': stock,
    });
  }

  Future<void> deleteMedicine(String docId) {
    return _medicines.doc(docId).delete();
  }
}