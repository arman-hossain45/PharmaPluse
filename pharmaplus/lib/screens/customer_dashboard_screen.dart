import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/firebase_service.dart';
import '../service/auth_service.dart'; 

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService(); 
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _checkCustomerRole();
  }


  Future<void> _checkCustomerRole() async {
    String? role = await _authService.getCurrentUserRole();
    if (!mounted) return;

    if (role != 'customer') {
      await _authService.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অ্যাক্সেস নিষিদ্ধ! শুধু কাস্টমাররা এখানে প্রবেশ করতে পারবেন।'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  void _addToCart(String medicineName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$medicineName কার্টে যোগ করা হয়েছে!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'দেখুন',
          textColor: Colors.white,
          onPressed: () {
            // পরে কার্ট স্ক্রিনে নেভিগেট করা যাবে
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কাস্টমার হোম'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          // সার্চ বক্স
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ওষুধ খুঁজুন',
                hintText: 'ওষুধের নাম লিখুন...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),

          // মেডিসিন লিস্ট
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getMedicines(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.teal));
                }

                if (snapshot.hasError) {
                  return Center(child: Text('এরর: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'কোনো ওষুধ পাওয়া যায়নি',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                // সার্চ অনুযায়ী ফিল্টার
                final allMedicines = snapshot.data!.docs;
                final filteredMedicines = allMedicines.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  return name.contains(_searchQuery);
                }).toList();

                if (filteredMedicines.isEmpty) {
                  return const Center(
                    child: Text(
                      'আপনার অনুসন্ধানের সাথে মিলছে না',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredMedicines.length,
                  itemBuilder: (context, index) {
                    final medicine = filteredMedicines[index];
                    final data = medicine.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'অজানা ওষুধ';
                    final price = data['price'] ?? '০';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 6,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.medical_services, color: Colors.teal, size: 32),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'মূল্য: ৳$price',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        trailing: ElevatedButton.icon(
                          onPressed: () => _addToCart(name),
                          icon: const Icon(Icons.shopping_cart, size: 18),
                          label: const Text('কিনুন'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
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