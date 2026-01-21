import 'package:flutter/material.dart';

class MedicationsInfoScreen extends StatelessWidget {
  const MedicationsInfoScreen({super.key});

  // 🌿 Stylish info card
  Widget infoCard({
    required IconData icon,
    required String title,
    required String desc,
    Color color = Colors.teal,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.9),
                      color.withOpacity(0.6),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            desc,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ❓ FAQ / Expandable info
  Widget faqTile(String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        children: [
          Text(
            desc,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          )
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
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text("Medication Guidelines"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 🌈 Hero Header
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
                Icon(Icons.medication,
                    color: Colors.white, size: 46),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Safe medicine usage helps you recover faster and stay healthy.",
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

          const SizedBox(height: 32),

          // 📋 Core Guidelines
          infoCard(
            icon: Icons.check_circle_outline,
            title: "Correct Dosage",
            desc:
                "Always take medicines exactly as prescribed. Never increase or reduce the dose on your own.",
          ),
          infoCard(
            icon: Icons.schedule,
            title: "Take on Time",
            desc:
                "Taking medicines at the same time every day ensures proper effectiveness.",
          ),
          infoCard(
            icon: Icons.warning_amber_rounded,
            title: "Avoid Overdose",
            desc:
                "Overdose can cause serious side effects. If you feel unwell, consult your doctor immediately.",
            color: Colors.redAccent,
          ),
          infoCard(
            icon: Icons.restaurant,
            title: "Food Instructions",
            desc:
                "Some medicines work best with food, while others require an empty stomach.",
          ),

          const SizedBox(height: 28),

          // ⚠️ Section Title
          const Text(
            "Important Questions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          faqTile(
            "Can I stop medicine when I feel better?",
            "No. You should always complete the full course to avoid relapse or resistance.",
          ),
          faqTile(
            "What if I miss a dose?",
            "Take it as soon as you remember unless it's close to the next dose.",
          ),
          faqTile(
            "Can I take multiple medicines together?",
            "Some medicines interact with each other. Always consult your doctor or pharmacist.",
          ),

          const SizedBox(height: 30),

          // 💡 Pro Tip Box
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Colors.teal.withOpacity(0.12),
                  Colors.teal.withOpacity(0.05),
                ],
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline,
                    color: Colors.teal.shade700, size: 32),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    "Pro Tip: Keep medicines in original packaging and store them away from heat and children.",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
