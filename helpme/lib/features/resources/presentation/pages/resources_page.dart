import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Resource Hub',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildResourceItem(
            'Managing Exam Stress',
            'Video • 12 min',
            Icons.videocam_outlined,
          ),
          _buildResourceItem(
            'Guided Morning Meditation',
            'Audio • 10 min',
            Icons.graphic_eq_outlined,
          ),
          _buildResourceItem(
            'Understanding Anxiety',
            'Article • 8 min read',
            Icons.description_outlined,
          ),
          _buildResourceItem(
            '5-Minute Mindful Breathing',
            'Exercise • 5 min',
            Icons.spa_outlined,
          ),
          _buildResourceItem(
            'Building Resilience',
            'Video • 15 min',
            Icons.accessibility_new_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF8DBDBA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF8DBDBA)),
        ),
        title: Text(
          title,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
