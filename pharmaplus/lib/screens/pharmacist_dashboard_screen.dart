import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/firebase_service.dart';

class PharmacistDashboardScreen extends StatefulWidget {
  const PharmacistDashboardScreen({super.key});

  @override
  State<PharmacistDashboardScreen> createState() =>
      _PharmacistDashboardScreenState();
}

class _PharmacistDashboardScreenState extends State<PharmacistDashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _addMedicine() async {
    if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      try {
        await _firebaseService.addMedicine(
          _nameController.text.trim(),
          _priceController.text.trim(),
        );
        _nameController.clear();
        _priceController.clear();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Medicine added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _editMedicine(String docId, String currentName, String currentPrice) {
    _nameController.text = currentName;
    _priceController.text = currentPrice;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Medicine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Medicine Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () { _nameController.clear(); _priceController.clear(); Navigator.pop(context); }, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firebaseService.updateMedicine(docId, _nameController.text.trim(), _priceController.text.trim());
                _nameController.clear();
                _priceController.clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medicine updated successfully!'), backgroundColor: Colors.green));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteMedicine(String docId, String medicineName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text('Are you sure you want to delete "$medicineName"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firebaseService.deleteMedicine(docId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medicine deleted successfully!'), backgroundColor: Colors.red));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    _nameController.clear();
    _priceController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Medicine'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Medicine Name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: _addMedicine, style: ElevatedButton.styleFrom(backgroundColor: Colors.teal), child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacist Dashboard'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.teal, onPressed: _showAddDialog, child: const Icon(Icons.add)),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService.getMedicines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text('No medicines added yet', style: TextStyle(fontSize: 18, color: Colors.grey)));

          final medicines = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              final docId = medicine.id;
              final data = medicine.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'Unknown';
              final price = data['price'] ?? '0';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.medication, color: Colors.teal, size: 28)),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text('Price: \$$price', style: const TextStyle(color: Colors.teal, fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editMedicine(docId, name, price)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteMedicine(docId, name)),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
