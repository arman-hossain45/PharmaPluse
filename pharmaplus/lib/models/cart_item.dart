// lib/model/cart_item.dart
class CartItem {
  final String medicineId;
  final String name;
  final double price;
  int quantity; // Can be modified

  CartItem({
    required this.medicineId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  // Factory to convert Firestore Map to CartItem object
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      medicineId: map['medicineId'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
    );
  }

  // Method to convert CartItem object back to a Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'medicineId': medicineId,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}