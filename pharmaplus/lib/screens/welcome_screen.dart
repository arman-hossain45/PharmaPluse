import 'package:flutter/material.dart';
import 'registration_screen.dart'; // Ensure this file exists
import 'pharmacist_login_screen.dart';
import 'customer_login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onLoginAsPharmacist;
  final VoidCallback onLoginAsCustomer;

  const WelcomeScreen({
    super.key,
    required this.onLoginAsPharmacist,
    required this.onLoginAsCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const Icon(Icons.medical_services, size: 100, color: Colors.teal),
                    const SizedBox(height: 16),
                    const Text('Pharma Plus', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal)),
                    const Text('Your trusted health science partner', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 50),
                    const Text('Login as:', style: TextStyle(fontSize: 18, color: Colors.black54)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.local_pharmacy),
                        onPressed: onLoginAsPharmacist,
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor: Colors.teal.shade400,
                            foregroundColor: Colors.white,
                        ),
                        label: const Text('Login as Pharmacist', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.person),
                        onPressed: onLoginAsCustomer,
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                        ),
                        label: const Text('Login as Customer', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                        onPressed: () {
                            // FIX: Removed 'const' keyword to resolve "Not a constant expression" error
                            Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (_) => RegistrationScreen()),
                            );
                        },
                        child: const Text("Don't have an account? Register here.", style: TextStyle(color: Colors.teal)),
                    ),
                ],
            ),
        ),
    );
  }
}