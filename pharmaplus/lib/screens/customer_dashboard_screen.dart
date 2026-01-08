import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/firebase_service.dart';
import '../service/auth_service.dart';
import 'welcome_screen.dart'; 
import 'customer_login_screen.dart'; 
import 'pharmacist_login_screen.dart'; 

class PharmacistDashboardScreen extends StatefulWidget {
  const PharmacistDashboardScreen({super.key});

  @override
  State<PharmacistDashboardScreen> createState() => _PharmacistDashboardScreenState();
}

class _PharmacistDashboardScreenState extends State<PharmacistDashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  Future<void> _signOut() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => WelcomeScreen(
          onLoginAsPharmacist: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacistLoginScreen())),
          onLoginAsCustomer: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerLoginScreen())),
        )),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _clearControllers() {
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();
  }

  void _showAddEditDialog({DocumentSnapshot? docToEdit}) {
    bool isEditing = docToEdit != null;
    _clearControllers();

    if (isEditing) {
      final data = docToEdit.data() as Map<String, dynamic>;
      _nameController.text = data['name'] ?? '';
      _priceController.text = (data['price'] as num?)?.toString() ?? ''; 
      _stockController.text = (data['stock'] as int?)?.toString() ?? '0';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Medicine' : 'Add New Medicine'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              TextField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isEmpty || _priceController.text.isEmpty || _stockController.text.isEmpty) {
                if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields.')),
                    );
                }
                return;
              }
              try {
                // CORRECT: Parse price to num and stock to int 
                final num price = num.parse(_priceController.text.trim());
                final int stock = int.parse(_stockController.text.trim());

                if (isEditing) {
                  await _firebaseService.updateMedicineWithStock(
                    docToEdit!.id,
                    _nameController.text.trim(),
                    price, 
                    stock,
                  );
                } else {
                  await _firebaseService.addMedicineWithStock(
                    _nameController.text.trim(),
                    price, 
                    stock,
                  );
                }
                if (mounted) Navigator.pop(context);
              } catch (e) {
                if(mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid number input for Price or Stock.')),
                  );
                }
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacist Dashboard (Inventory)'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(onPressed: _signOut, icon: const Icon(Icons.logout, color: Colors.white)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService.getMedicines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No medicines found. Add some!'));
          }

          final medicines = snapshot.data!.docs;

          return ListView.builder(
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              final data = medicine.data() as Map<String, dynamic>;
              
              final name = data['name'] ?? 'N/A';
              
              final num priceNum = data['price'] as num? ?? 0.0;
              final String price = priceNum.toStringAsFixed(2);
              
              final String stock = (data['stock'] as int? ?? 0).toString();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Price: \$$price | Stock: $stock'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showAddEditDialog(docToEdit: medicine),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _firebaseService.deleteMedicine(medicine.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}