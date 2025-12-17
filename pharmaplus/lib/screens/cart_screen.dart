import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    if (currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      DocumentSnapshot cartDoc = await FirebaseFirestore.instance
          .collection('carts')
          .doc(currentUser!.uid)
          .get();

      if (cartDoc.exists && cartDoc.data() != null) {
        final data = cartDoc.data() as Map<String, dynamic>;
        final List<dynamic> itemsDynamic = data['items'] ?? [];

        setState(() {
          cartItems = itemsDynamic.map((item) {
            return Map<String, dynamic>.from(item as Map);
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('কার্ট লোড করতে এরর: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('কার্ট লোড করতে সমস্যা: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + (item['price'] as num) * (item['quantity'] as num));
  }

  Future<void> _updateQuantity(String medicineId, int newQuantity) async {
    if (newQuantity <= 0) {
      await _removeFromCart(medicineId);
      return;
    }

    setState(() {
      final item = cartItems.firstWhere((element) => element['medicineId'] == medicineId);
      item['quantity'] = newQuantity;
    });

    await _saveCartToFirestore();
  }

  Future<void> _removeFromCart(String medicineId) async {
    setState(() {
      cartItems.removeWhere((item) => item['medicineId'] == medicineId);
    });
    await _saveCartToFirestore();
  }

  Future<void> _saveCartToFirestore() async {
    if (currentUser == null || cartItems.isEmpty) {
      if (currentUser != null) {
        await FirebaseFirestore.instance.collection('carts').doc(currentUser!.uid).delete();
      }
      return;
    }

    await FirebaseFirestore.instance.collection('carts').doc(currentUser!.uid).set({
      'items': cartItems,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _placeOrder() async {
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('কার্ট খালি!'), backgroundColor: Colors.orange),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': currentUser!.uid,
        'userEmail': currentUser!.email,
        'items': cartItems,
        'totalPrice': totalPrice,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // কার্ট খালি করা
      await FirebaseFirestore.instance.collection('carts').doc(currentUser!.uid).delete();

      setState(() {
        cartItems.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অর্ডার সফলভাবে প্লেস করা হয়েছে!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('অর্ডার করতে সমস্যা: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('আপনার কার্ট'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
                      const SizedBox(height: 20),
                      const Text(
                        'আপনার কার্ট খালি',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'ওষুধ যোগ করে কিনুন',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final name = item['name'] as String;
                          final price = (item['price'] as num).toDouble();
                          final quantity = item['quantity'] as int;
                          final medicineId = item['medicineId'] as String;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 6,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.medical_services, color: Colors.teal, size: 36),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'মূল্য: ৳${price.toStringAsFixed(0)} x $quantity = ৳${(price * quantity).toStringAsFixed(0)}',
                                          style: const TextStyle(color: Colors.teal, fontSize: 15, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                            onPressed: () => _updateQuantity(medicineId, quantity - 1),
                                          ),
                                          Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                            onPressed: () => _updateQuantity(medicineId, quantity + 1),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removeFromCart(medicineId),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // টোটাল প্রাইস এবং অর্ডার বাটন
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('মোট মূল্য', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              Text('৳${totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _placeOrder,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                              ),
                              child: const Text(
                                'অর্ডার প্লেস করুন',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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