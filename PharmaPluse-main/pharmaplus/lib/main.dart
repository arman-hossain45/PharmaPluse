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
      home: const AuthWrapper(),
    );
  }
}

// লগইন আছে কিনা চেক করে সঠিক স্ক্রিন দেখাবে
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // লোডিং দেখানো
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.teal)),
          );
        }

        // ইউজার লগইন আছে কিনা
        if (snapshot.hasData) {
          // লগইন আছে – role চেক করে ড্যাশবোর্ডে পাঠানো
          return const RoleBasedDashboard();
        } else {
          // লগইন নেই – Welcome Screen দেখানো
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

// role অনুযায়ী সঠিক ড্যাশবোর্ড দেখানো
class RoleBasedDashboard extends StatelessWidget {
  const RoleBasedDashboard({super.key});

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
      print('Role পড়তে এরর: $e');
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
          // role না পেলে বা ভুল হলে লগআউট করে Welcome-এ পাঠানো
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