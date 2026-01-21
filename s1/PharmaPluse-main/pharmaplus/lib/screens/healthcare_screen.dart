import 'package:flutter/material.dart';

class HealthCareScreen extends StatelessWidget {
  const HealthCareScreen({super.key});

  // 🌿 Reusable Health Card
  Widget healthCard({
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
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.85),
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

  // ❓ Expandable Info
  Widget expandableInfo(String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        children: [
          Text(
            desc,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.5,
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
        title: const Text('Health Care'),
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
                  color: Colors.teal.withOpacity(0.45),
                  blurRadius: 26,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.favorite,
                    color: Colors.white, size: 46),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Healthy life starts with consistent daily care and awareness",
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

          const SizedBox(height: 30),

          // 🩺 Core Health Care
          const Text(
            "Daily Health Essentials",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          healthCard(
            icon: Icons.monitor_heart,
            title: 'Blood Pressure Monitoring',
            desc:
                'Check your blood pressure regularly to reduce the risk of heart disease and stroke.',
          ),
          healthCard(
            icon: Icons.bloodtype,
            title: 'Diabetes Care',
            desc:
                'Maintain healthy blood sugar levels through diet, exercise, and proper medication.',
            color: Colors.redAccent,
          ),
          healthCard(
            icon: Icons.fitness_center,
            title: 'Daily Exercise',
            desc:
                'At least 30 minutes of physical activity improves heart health and energy levels.',
          ),
          healthCard(
            icon: Icons.bedtime,
            title: 'Proper Sleep',
            desc:
                'Getting 7–8 hours of sleep daily strengthens immunity and mental health.',
          ),

          const SizedBox(height: 28),

          // ❓ Extra Health Awareness
          const Text(
            "Health Awareness",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          expandableInfo(
            "How often should I check my BP?",
            "If you have high blood pressure, check it daily. Otherwise, weekly monitoring is recommended.",
          ),
          expandableInfo(
            "Why is sleep important?",
            "Sleep helps your body recover, supports brain function, and balances hormones.",
          ),
          expandableInfo(
            "Is daily exercise necessary?",
            "Yes. Even light exercise like walking helps prevent chronic diseases.",
          ),

          const SizedBox(height: 30),

          // 💡 Health Tip
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
                    "Health Tip: Regular check-ups and a balanced lifestyle help prevent major illnesses.",
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
