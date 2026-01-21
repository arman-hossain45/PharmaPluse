import 'package:flutter/material.dart';
import '../service/firebase_service.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final nameController = TextEditingController();
  final categoryController = TextEditingController(text: "Tablet");
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  final FirebaseService firebaseService = FirebaseService();
  bool loading = false;

  Future<void> _saveMedicine() async {
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

    setState(() => loading = true);

    await firebaseService.addFullMedicine(
      name: nameController.text.trim(),
      category: categoryController.text.trim(),
      description: descriptionController.text.trim(),
      price: double.tryParse(priceController.text) ?? 0,
      rating: 4.5,
      reviews: 0,
      stock: int.tryParse(stockController.text) ?? 0,
    );

    setState(() => loading = false);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Medicine added successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("নতুন ঔষধ যোগ করুন"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _field("ঔষধের নাম", nameController),
            _field("Category", categoryController),
            _field("Description", descriptionController, maxLines: 3),
            _field("Price", priceController, type: TextInputType.number),
            _field("Stock", stockController, type: TextInputType.number),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: loading ? null : _saveMedicine,
          child: loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : const Text("Add"),
        ),
      ],
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
}
