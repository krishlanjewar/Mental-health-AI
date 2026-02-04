import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MeditationPage extends StatelessWidget {
  const MeditationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: Text(
          'Meditation',
          style: GoogleFonts.outfit(color: const Color(0xFFE65100)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: const Color(0xFFE65100)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMeditationCard('Morning Calm', '10 mins', Icons.sunny),
          _buildMeditationCard('Deep Sleep', '20 mins', Icons.nightlight_round),
          _buildMeditationCard('Stress Relief', '15 mins', Icons.spa),
          _buildMeditationCard('Focus', '5 mins', Icons.timer),
        ],
      ),
    );
  }

  Widget _buildMeditationCard(String title, String duration, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFE65100), size: 28),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                duration,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(
            Icons.play_circle_fill,
            color: Color(0xFFE65100),
            size: 40,
          ),
        ],
      ),
    );
  }
}
