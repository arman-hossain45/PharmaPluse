import 'package:flutter/material.dart';

class AddMedicineReminderScreen extends StatefulWidget {
  const AddMedicineReminderScreen({super.key});

  @override
  State<AddMedicineReminderScreen> createState() =>
      _AddMedicineReminderScreenState();
}

class _AddMedicineReminderScreenState
    extends State<AddMedicineReminderScreen> {
  final TextEditingController medicineController =
      TextEditingController();
  final TextEditingController timeController =
      TextEditingController();

  // ⏰ Time Picker
  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        timeController.text = time.format(context);
      });
    }
  }

  void _save() {
    if (medicineController.text.isEmpty ||
        timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'medicine': medicineController.text.trim(),
      'time': timeController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text('Add Medicine Reminder'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 🌈 Header Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2EC4B6),
                  Color(0xFF1B998B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.4),
                  blurRadius: 22,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.alarm,
                    color: Colors.white, size: 42),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Add reminder so you never miss your medicine",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 💊 Medicine Name Field
          _inputField(
            controller: medicineController,
            label: "Medicine Name",
            hint: "e.g. Paracetamol",
            icon: Icons.medication,
          ),

          const SizedBox(height: 20),

          // ⏰ Time Picker Field
          GestureDetector(
            onTap: pickTime,
            child: AbsorbPointer(
              child: _inputField(
                controller: timeController,
                label: "Reminder Time",
                hint: "Select time",
                icon: Icons.schedule,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // 💾 Save Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                "Save Reminder",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✏️ Reusable Input Field
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
