import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'screens/welcome_screen.dart';
import 'screens/pharmacist_login_screen.dart';
import 'screens/customer_login_screen.dart';
import 'screens/pharmacist_dashboard_screen.dart';
import 'screens/customer_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PharmaPlus());
}

class PharmaPlus extends StatelessWidget {
  const PharmaPlus({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharma Plus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const AuthStateChecker(),
    );
  }
}

// Checks if user is logged in or not
class AuthStateChecker extends StatelessWidget {
  const AuthStateChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.teal)),
          );
        }

        if (snapshot.hasData) {
          // User is logged in → check role and go to correct dashboard
          return const RoleBasedScreen();
        } else {
          // No user logged in → show Welcome Screen
          return WelcomeScreen(
            onLoginAsPharmacist: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PharmacistLoginScreen()),
              );
            },
            onLoginAsCustomer: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerLoginScreen()),
              );
            },
          );
        }
      },
    );
  }
}

// Checks user's role from Firestore and routes to correct dashboard
class RoleBasedScreen extends StatelessWidget {
  const RoleBasedScreen({super.key});

  Future<String?> _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return data['role'] as String?;
      }
    } catch (e) {
      print('Error reading role: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.teal)),
          );
        }

        final role = snapshot.data;

        if (role == 'pharmacist') {
          return const PharmacistDashboardScreen();
        } else if (role == 'customer') {
          return const CustomerDashboardScreen();
        } else {
          // Invalid or no role → log out and go to Welcome
          FirebaseAuth.instance.signOut();
          return WelcomeScreen(
            onLoginAsPharmacist: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PharmacistLoginScreen()),
              );
            },
            onLoginAsCustomer: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerLoginScreen()),
              );
            },
          );
        }
      },
    );
  }
}