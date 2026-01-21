import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/firebase_service.dart';
import '../service/auth_service.dart';

class PharmacistDashboardScreen extends StatefulWidget {
  const PharmacistDashboardScreen({super.key});

  @override
  State<PharmacistDashboardScreen> createState() =>
      _PharmacistDashboardScreenState();
}

class _PharmacistDashboardScreenState
    extends State<PharmacistDashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();

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
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  void _logout() async {
    await _authService.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  // ================= ADD MEDICINE =================
  void _showAddFullMedicineDialog() {
    final nameController = TextEditingController();
    final categoryController =
        TextEditingController(text: "Tablet");
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("নতুন ঔষধ যোগ করুন"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _field("ঔষধের নাম", nameController),
                _field("Category", categoryController),
                _field(
                  "Description",
                  descriptionController,
                  maxLines: 3,
                ),
                _field(
                  "Price",
                  priceController,
                  type: TextInputType.number,
                ),
                _field(
                  "Stock",
                  stockController,
                  type: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    categoryController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    stockController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("সব ফিল্ড পূরণ করুন")),
                  );
                  return;
                }

                await _firebaseService.addFullMedicine(
                  name: nameController.text.trim(),
                  category: categoryController.text.trim(),
                  description: descriptionController.text.trim(),
                  price: double.tryParse(priceController.text) ?? 0,
                  rating: 4.5,
                  reviews: 0,
                  stock: int.tryParse(stockController.text) ?? 0,
                );

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Medicine added successfully"),
                  ),
                );
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pharmacist Panel"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: _showAddFullMedicineDialog,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Add New Medicine",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔥 MEDICINE LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getMedicines(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final medicines = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    final data =
                        medicines[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.medication,
                          color: Colors.teal,
                        ),
                        title: Text(
                          (data['name'] ?? '').toString().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${data['category']} • ৳${data['price']} • Stock: ${data['stock']}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _firebaseService
                              .deleteMedicine(medicines[index].id),
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
}
