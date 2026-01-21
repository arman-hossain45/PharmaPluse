import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'congratulations_screen.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  Future<void> placeOrder(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartDoc = await FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid)
        .get();

    if (!cartDoc.exists) return;

    final items = cartDoc['items'];

    await FirebaseFirestore.instance.collection('orders').add({
      'userId': user.uid,
      'items': items,
      'total': totalAmount,
      'paymentMethod': 'bKash / Nagad',
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Clear cart
    await FirebaseFirestore.instance
        .collection('carts')
        .doc(user.uid)
        .delete();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CongratulationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Choose Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.payment, color: Colors.pink),
              title: const Text('bKash'),
              onTap: () => placeOrder(context),
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.orange),
              title: const Text('Nagad'),
              onTap: () => placeOrder(context),
            ),

            const Spacer(),

            Text(
              'Total: ৳${totalAmount.toStringAsFixed(0)}',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}