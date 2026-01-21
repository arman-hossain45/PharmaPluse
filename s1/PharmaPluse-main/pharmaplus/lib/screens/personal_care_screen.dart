import 'package:flutter/material.dart';

class PersonalCareScreen extends StatelessWidget {
  const PersonalCareScreen({super.key});

  // 🌿 Reusable Care Card
  Widget careCard({
    required IconData icon,
    required String title,
    required String desc,
    Color color = Colors.teal,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.8),
                  color.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🗂 Category Chip
  Widget categoryChip(String text, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F9F7),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Personal Care'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 🌈 HERO HEADER
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2EC4B6),
                  Color(0xFF1B998B),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.spa,
                    color: Colors.white, size: 46),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Care for your body and mind for a healthier lifestyle",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // 🗂 Categories
          const Text(
            "Categories",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                // categories
              ],
            ),
          ),

          Row(
            children: [
              categoryChip("Skin", Icons.face),
              categoryChip("Hygiene", Icons.clean_hands),
              categoryChip("Dental", Icons.brush),
              categoryChip("Health", Icons.favorite),
            ],
          ),

          const SizedBox(height: 30),

          // 💆 Skin Care Section
          const Text(
            "Skin Care",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          careCard(
            icon: Icons.face,
            title: 'Daily Face Care',
            desc:
                'Wash your face twice daily using a gentle cleanser and apply moisturizer.',
          ),
          careCard(
            icon: Icons.wb_sunny,
            title: 'Sun Protection',
            desc:
                'Use sunscreen to protect your skin from harmful UV rays.',
          ),

          const SizedBox(height: 24),

          // 🧼 Hygiene Section
          const Text(
            "Hygiene",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          careCard(
            icon: Icons.clean_hands,
            title: 'Hand Hygiene',
            desc:
                'Wash hands frequently to prevent infections and illnesses.',
          ),
          careCard(
            icon: Icons.shower,
            title: 'Regular Bath',
            desc:
                'Maintain body cleanliness by bathing regularly.',
          ),

          const SizedBox(height: 24),

          // 💧 Wellness Section
          const Text(
            "Wellness",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          careCard(
            icon: Icons.water_drop,
            title: 'Stay Hydrated',
            desc:
                'Drink sufficient water throughout the day to keep your body healthy.',
          ),
          careCard(
            icon: Icons.nightlight_round,
            title: 'Proper Sleep',
            desc:
                'Ensure 7–8 hours of sleep daily for mental and physical wellness.',
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
