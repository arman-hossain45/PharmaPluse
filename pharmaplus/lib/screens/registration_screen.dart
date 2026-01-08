import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// FIX: Path to custom_button is now valid
import '../widgets/custom_button.dart'; 
import 'pharmacist_login_screen.dart';
import 'customer_login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  // FIX: Removed the 'role' parameter, as role is selected internally.
  const RegistrationScreen({super.key}); 

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // ... (existing controllers) ...
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedRole;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    // ... (existing _register logic) ...
    if (_selectedRole == null || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name and select a role.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Save user details and role in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': _selectedRole, // IMPORTANT: Saves the role
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3. Success feedback and navigation
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful! Please login.')),
      );

      // Navigate back to the appropriate login screen
      if (_selectedRole == 'pharmacist') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PharmacistLoginScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CustomerLoginScreen()));
      }

    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Account Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ... (existing TextFields) ...
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32),

            // Role Selection Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Registering as',
                border: OutlineInputBorder(),
              ),
              value: _selectedRole,
              hint: const Text('Select Role (Customer or Pharmacist)'),
              items: const [
                DropdownMenuItem(value: 'customer', child: Text('Customer')),
                DropdownMenuItem(value: 'pharmacist', child: Text('Pharmacist')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
            ),
            const SizedBox(height: 48),

            // Registration Button (FIXED: Uses CustomButton)
            CustomButton(
              onPressed: _isLoading ? null : _register,
              text: _isLoading ? 'Registering...' : 'Register',
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}