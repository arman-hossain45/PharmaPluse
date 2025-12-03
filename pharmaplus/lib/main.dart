import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'screens/welcome_screen.dart';
import 'screens/pharmacist_login_screen.dart';
import 'screens/customer_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PharmaPlus());
}

class PharmaPlus extends StatelessWidget {
  const PharmaPlus({Key? key}) : super(key: key);

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
      home: Builder(
        builder: (context) => WelcomeScreen(
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
        ),
      ),
    );
  }
}


