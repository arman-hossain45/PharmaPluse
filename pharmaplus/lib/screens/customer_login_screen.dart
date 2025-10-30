import 'package:flutter/material.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Login")),
      body: const Center(
        child: Text("Customer Login Page"),
      ),
    );
  }
}
