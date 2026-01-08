import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    if (currentUser == null) {
      setState(() => isLoading = false);
      return;
    }

    final cartDoc = await FirebaseFirestore.instance
        .collection('carts')
        .doc(currentUser!.uid)
        .get();

    if (cartDoc.exists && cartDoc.data() != null) {
      final data = cartDoc.data()!;
      final List items = data['items'] ?? [];

      setState(() {
        cartItems = items.map((e) => Map<String, dynamic>.from(e)).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  double get totalPrice {
    return cartItems.fold(
      0.0,
      (sum, item) =>
          sum + (item['price'] as num) * (item['quantity'] as num),
    );
  }

  Future<void> updateQty(String id, int qty) async {
    if (qty <= 0) {
      removeItem(id);
      return;
    }

    setState(() {
      cartItems.firstWhere((e) => e['medicineId'] == id)['quantity'] = qty;
    });

    await saveCart();
  }

  Future<void> removeItem(String id) async {
    setState(() {
      cartItems.removeWhere((e) => e['medicineId'] == id);
    });

    await saveCart();
  }

  Future<void> saveCart() async {
    if (currentUser == null) return;

    if (cartItems.isEmpty) {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(currentUser!.uid)
          .delete();
      return;
    }

    await FirebaseFirestore.instance
        .collection('carts')
        .doc(currentUser!.uid)
        .set({
      'items': cartItems,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আপনার কার্ট'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'আপনার কার্ট খালি',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Column(
                  children: [
                    // 🔹 Cart Items
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final id = item['medicineId'];
                          final name = item['name'];
                          final price =
                              (item['price'] as num).toDouble();
                          final qty = item['quantity'];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(
                                name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  '৳$price x $qty = ৳${price * qty}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () =>
                                        updateQty(id, qty - 1),
                                  ),
                                  Text('$qty'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () =>
                                        updateQty(id, qty + 1),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => removeItem(id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // 🔹 Bottom Section (THIS IS WHERE YOUR CODE GOES)
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'মোট মূল্য',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '৳${totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // ✅ ORDER BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                              ),

                              // 🔽 🔽 🔽 YOUR onPressed CODE IS HERE
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PaymentScreen(
                                      totalAmount: totalPrice,
                                    ),
                                  ),
                                );
                              },
                              // 🔼 🔼 🔼

                              child: const Text(
                                'অর্ডার করুন',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
