import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../service/firebase_service.dart';
import '../service/auth_service.dart';

import 'cart_screen.dart';
import 'telemedicine_screen.dart';
import 'medicine_reminder_screen.dart';

// info screens
import 'healthcare_screen.dart';
import 'medications_info_screen.dart';
import 'personal_care_screen.dart';

// UI widgets
import 'home_ui_widgets.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

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
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  // ================= ADD TO CART =================
  Future<void> _addToCart(String name, String id, double price) async {
    if (currentUser == null) return;

    final cartRef =
        FirebaseFirestore.instance.collection('carts').doc(currentUser!.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(cartRef);

      if (!snapshot.exists) {
        transaction.set(cartRef, {
          'items': [
            {
              'medicineId': id,
              'name': name,
              'price': price,
              'quantity': 1,
            }
          ],
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        List items = snapshot['items'];
        bool found = false;

        for (var item in items) {
          if (item['medicineId'] == id) {
            item['quantity']++;
            found = true;
            break;
          }
        }

        if (!found) {
          items.add({
            'medicineId': id,
            'name': name,
            'price': price,
            'quantity': 1,
          });
        }

        transaction.update(cartRef, {
          'items': items,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name added to cart')),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9F7),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          'Customer Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartScreen()),
          );
        },
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HealthcareBanner(),
              const SizedBox(height: 24),

              // 🔥 QUICK ACTIONS
              Row(
                children: [
                  _quickActionBig(
                    icon: Icons.alarm,
                    title: 'Medicine\nReminder',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MedicineReminderScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _quickActionBig(
                    icon: Icons.calendar_month,
                    title: 'Book\nAppointment',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TelemedicineScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  _quickActionBig(
                    icon: Icons.call,
                    title: 'Emergency\nCall',
                    color: Colors.red,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 🗂 CATEGORIES
              const Text(
                'Browse Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _categoryBig(
                    icon: Icons.favorite,
                    title: 'Health\nCare',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HealthCareScreen(),
                        ),
                      );
                    },
                  ),
                  _categoryBig(
                    icon: Icons.medication,
                    title: 'Medications',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MedicationsInfoScreen(),
                        ),
                      );
                    },
                  ),
                  _categoryBig(
                    icon: Icons.spa,
                    title: 'Personal\nCare',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PersonalCareScreen(),
                        ),
                      );
                    },
                  ),
                  _categoryBig(
                    icon: Icons.devices,
                    title: 'Devices',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),

              TelemedicineBanner(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TelemedicineScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              const Text(
                'Popular Medicines',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // 💊 MEDICINES GRID
              StreamBuilder<QuerySnapshot>(
                stream: _firebaseService.getMedicines(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final medicines = snapshot.data!.docs;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: medicines.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final doc = medicines[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final name = data['name'] ?? '';
                      final category = data['category'] ?? 'Tablet';
                      final description =
                          data['description'] ?? 'Quality Medication';
                      final price =
                          double.tryParse(data['price'].toString()) ?? 0;
                      final rating =
                          double.tryParse(data['rating'].toString()) ?? 0;
                      final reviews = data['reviews'] ?? 0;
                      final stock = data['stock'] ?? 0;

                      return _medicineCard(
                        name: name,
                        category: category,
                        description: description,
                        price: price,
                        rating: rating,
                        reviews: reviews,
                        stock: stock,
                        onAdd: () => _addToCart(name, doc.id, price),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= MEDICINE CARD =================
  Widget _medicineCard({
    required String name,
    required String category,
    required String description,
    required double price,
    required double rating,
    required int reviews,
    required int stock,
    required VoidCallback onAdd,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 90,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.medication,
                      color: Colors.teal, size: 28),
                ),
                Chip(label: Text(category)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text('$rating ($reviews)',
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                Text('৳$price',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal)),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: stock > 0 ? onAdd : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          stock > 0 ? Colors.teal : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      stock > 0 ? 'Add to Cart' : 'Unavailable',
                      style: TextStyle(
                          color: stock > 0
                              ? Colors.white
                              : Colors.grey.shade600),
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

  // ================= HELPERS =================
  Widget _quickActionBig({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 10),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryBig({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.teal, size: 34),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}


