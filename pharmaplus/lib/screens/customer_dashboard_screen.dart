import 'package:flutter/material.dart';

// Dummy data (later pharmacist এর CRUD data এর সাথে link হবে)
final List<Map<String, dynamic>> medicines = [
  {"name": "Paracetamol 500mg", "price": 5.99},
  {"name": "Napa Extra", "price": 6.50},
  {"name": "Seclo 20mg", "price": 8.00},
  {"name": "Losectil 40mg", "price": 9.50},
  {"name": "Amodis 250mg", "price": 12.00},
];

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() => _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Search অনুযায়ী filtered list তৈরি
    final filteredMedicines = medicines
        .where((medicine) =>
            medicine["name"].toString().toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Dashboard"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔍 Search Box
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search Medicine",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // 🧾 Medicine List
          Expanded(
            child: filteredMedicines.isEmpty
                ? const Center(
                    child: Text("No medicines found",
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  )
                : ListView.builder(
                    itemCount: filteredMedicines.length,
                    itemBuilder: (context, index) {
                      final medicine = filteredMedicines[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.medical_services, color: Colors.teal),
                          title: Text(medicine["name"]),
                          subtitle: Text("Price: \$${medicine["price"]}"),
                          trailing: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "${medicine['name']} added to cart (demo only)"),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text("Buy"),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
