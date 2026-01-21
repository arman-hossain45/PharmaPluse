import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_screen.dart'; // Import your CartScreen

class PharmaDrawer extends StatelessWidget {
  const PharmaDrawer({super.key});

  // লগআউট ফাংশন
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Welcome Screen-এ ফিরে যাওয়া
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Text('Pharma Plus', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              // Home (Dashboard)-এ থাকায় কোনো অ্যাকশন লাগবে না, বা Welcome-এ যাওয়ার কোড যোগ করুন
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('MedInfo'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to MedInfo screen (new screen create করুন)
              // Navigator.push(context, MaterialPageRoute(builder: (_) => MedInfoScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('My Orders'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to My Orders screen (new screen create করুন)
              // Navigator.push(context, MaterialPageRoute(builder: (_) => MyOrdersScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('My Carts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}