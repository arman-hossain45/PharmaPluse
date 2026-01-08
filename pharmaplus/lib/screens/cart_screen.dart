import 'package:flutter/material.dart';

// Placeholder for Cart Item data structure
class CartItem {
  final String name;
  final num price;
  int quantity;
  
  CartItem({required this.name, required this.price, this.quantity = 1});
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // --- Simulated Cart Data ---
  final List<CartItem> _cartItems = [
    CartItem(name: 'Blood Pressure Monitor', price: 45.99, quantity: 1),
    CartItem(name: 'Paracetamol 500mg', price: 5.99, quantity: 2),
  ];
  // ---------------------------

  void _proceedToCheckout() {
    if (_cartItems.isEmpty) return;
    // In a real app, this would initiate a payment process
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Proceeding to Payment... (Simulated)')),
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        _cartItems[index].quantity = newQuantity;
      } else {
        _cartItems.removeAt(index);
      }
    });
  }

  num _calculateSubtotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }
  
  // Hardcoded taxes for simulation
  static const double _taxRate = 0.10; // 10%
  static const num _deliveryFee = 4.00;

  @override
  Widget build(BuildContext context) {
    final subtotal = _calculateSubtotal();
    final tax = subtotal * _taxRate;
    final total = subtotal + tax + _deliveryFee;
    
    // Check if cart is empty (matches the far bottom-right screen in the flowchart)
    if (_cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Cart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Browse our medicines and add items to your cart.'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Continue Shopping', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
    
    // Cart with items (matches the bottom-second-to-last screen in the flowchart)
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _updateQuantity(index, item.quantity - 1),
                      ),
                      Text(item.quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _updateQuantity(index, item.quantity + 1),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Order Summary Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _buildSummaryRow('Subtotal', subtotal),
                  _buildSummaryRow('Delivery Fee', _deliveryFee),
                  _buildSummaryRow('Tax (10%)', tax),
                  const Divider(),
                  _buildSummaryRow('Total Amount', total, isTotal: true),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _proceedToCheckout,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: const Text('Place Order', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, num amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.red : Colors.black87,
              fontSize: isTotal ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }
}