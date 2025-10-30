import 'package:flutter/material.dart';

class PharmacistLoginScreen extends StatelessWidget {
  const PharmacistLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pharmacist Login")),
      body: const Center(
        child: Text("Pharmacist Login Page"),
      ),
    );
  }
}
