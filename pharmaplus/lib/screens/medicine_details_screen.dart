import 'package:flutter/material.dart';

class MedicineDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> medicineData;
  final String docId;
  
  // NOTE: In a real app, you would use a dedicated 'CartService' here
  // to manage the state of the shopping cart.
  
  const MedicineDetailsScreen({
    super.key,
    required this.medicineData,
    required this.docId,
  });

  void _addToCart(BuildContext context) {
    // --- Cart Service Logic Placeholder ---
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${medicineData['name']} added to cart! (Simulated)')),
    );
    // -------------------------------------
  }

  @override
  Widget build(BuildContext context) {
    final name = medicineData['name'] ?? 'N/A';
    final price = medicineData['price']?.toStringAsFixed(2) ?? '0.00';
    final stock = medicineData['stock'] ?? 0;
    
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Icon(Icons.medical_information, size: 100, color: Colors.teal),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$$price',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.red),
            ),
            const SizedBox(height: 10),
            Text(
              stock > 0 ? 'In Stock ($stock units)' : 'Out of Stock',
              style: TextStyle(color: stock > 0 ? Colors.green : Colors.red, fontSize: 16),
            ),
            const Divider(height: 40),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a placeholder description for the medicine details, covering usage, dosage, and side effects. '
              'In a real application, this information would be stored in Firestore.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: stock > 0 ? () => _addToCart(context) : null,
          icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          label: Text(
            stock > 0 ? 'Add to Cart' : 'Out of Stock',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}