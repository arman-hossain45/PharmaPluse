import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/firebase_service.dart';
import '../service/auth_service.dart';

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

  @override
  void initState() {
    super.initState();
    _checkPharmacistRole();
  }

  Future<void> _checkPharmacistRole() async {
    String? role = await _authService.getCurrentUserRole();
    if (!mounted) return;

    if (role != 'pharmacist') {
      await _authService.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অ্যাক্সেস নিষিদ্ধ! শুধু ফার্মাসিস্টরা এখানে প্রবেশ করতে পারবেন।'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  // Back বাটন ক্লিক করলে লগআউট করে Welcome Screen-এ পাঠাবে
  void _goBackToWelcome() async {
    await _authService.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _showAddDialog() {
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('নতুন ওষুধ যোগ করুন'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'ওষুধের নাম', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'মূল্য', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'স্টক সংখ্যা', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty && _priceController.text.isNotEmpty && _stockController.text.isNotEmpty) {
                try {
                  await _firebaseService.addMedicineWithStock(
                    _nameController.text.trim(),
                    _priceController.text.trim(),
                    int.parse(_stockController.text.trim()),
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ওষুধ সফলভাবে যোগ করা হয়েছে!'), backgroundColor: Colors.green),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('এরর: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('যোগ করুন'),
          ),
        ],
      ),
    );
  }

  void _editMedicine(String docId, String currentName, String currentPrice, int currentStock) {
    _nameController.text = currentName;
    _priceController.text = currentPrice;
    _stockController.text = currentStock.toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ওষুধ এডিট করুন'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'ওষুধের নাম', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'মূল্য', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'স্টক সংখ্যা', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firebaseService.updateMedicineWithStock(
                  docId,
                  _nameController.text.trim(),
                  _priceController.text.trim(),
                  int.parse(_stockController.text.trim()),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ওষুধ আপডেট সফল হয়েছে!'), backgroundColor: Colors.green),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('এরর: $e'), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text('আপডেট'),
          ),
        ],
      ),
    );
  }

  void _deleteMedicine(String docId, String medicineName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ওষুধ ডিলিট করুন'),
        content: Text('আপনি কি নিশ্চিত "$medicineName" ডিলিট করতে চান?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firebaseService.deleteMedicine(docId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ওষুধ ডিলিট সফল হয়েছে!'), backgroundColor: Colors.red),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('এরর: $e'), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ডিলিট'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacist Panel'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackToWelcome, // Back বাটন কাজ করবে – Welcome Screen-এ ফিরে যাবে
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _goBackToWelcome, // লগআউট বাটনও একই কাজ করবে
          ),
        ],
      ),
      body: Column(
        children: [
          // Add New Medicine Button
          GestureDetector(
            onTap: _showAddDialog,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'Add New Medicine',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Inventory Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.inventory, color: Colors.grey[600]),
                const SizedBox(width: 8),
                StreamBuilder<QuerySnapshot>(
                  stream: _firebaseService.getMedicines(),
                  builder: (context, snapshot) {
                    int count = snapshot.hasData ? snapshot.data!.docs.length : 0;
                    return Text(
                      '$count Medicines in Inventory',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Medicine List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getMedicines(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('এরর: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('এখনো কোনো ওষুধ যোগ করা হয়নি'));
                }

                final medicines = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = medicines[index];
                    final docId = medicine.id;
                    final data = medicine.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'অজানা ওষুধ';
                    final price = data['price'] ?? '০';
                    final stock = data['stock'] ?? 0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.medication,
                            color: Colors.teal,
                            size: 40,
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '৳$price',
                              style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Stock: $stock',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editMedicine(docId, name, price, stock),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteMedicine(docId, name),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}