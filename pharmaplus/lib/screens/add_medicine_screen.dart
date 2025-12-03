import 'package:flutter/material.dart';
import '../service/firebase_service.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Medicine Name",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: "Price",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await firebaseService.addMedicine(
                  nameController.text,
                  priceController.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Medicine Added Successfully!")),
                );

                nameController.clear();
                priceController.clear();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
