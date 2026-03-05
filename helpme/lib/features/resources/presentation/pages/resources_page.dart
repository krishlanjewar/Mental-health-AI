import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Video',
    'Audio',
    'Article',
    'Exercise',
  ];

  final List<Map<String, dynamic>> _allResources = [
    {
      'title': 'Managing Exam Stress',
      'type': 'Video',
      'duration': '12 min',
      'icon': Icons.videocam_outlined,
      'category': 'Video',
    },
    {
      'title': 'Guided Morning Meditation',
      'type': 'Audio',
      'duration': '10 min',
      'icon': Icons.graphic_eq_outlined,
      'category': 'Audio',
    },
    {
      'title': 'Understanding Anxiety',
      'type': 'Article',
      'duration': '8 min read',
      'icon': Icons.description_outlined,
      'category': 'Article',
    },
    {
      'title': '5-Minute Mindful Breathing',
      'type': 'Exercise',
      'duration': '5 min',
      'icon': Icons.spa_outlined,
      'category': 'Exercise',
    },
    {
      'title': 'Building Resilience',
      'type': 'Video',
      'duration': '15 min',
      'icon': Icons.accessibility_new_outlined,
      'category': 'Video',
    },
    {
      'title': 'Sleep Hygiene Tips',
      'type': 'Article',
      'duration': '5 min read',
      'icon': Icons.bed_outlined,
      'category': 'Article',
    },
    {
      'title': 'Focus Music Playlist',
      'type': 'Audio',
      'duration': '45 min',
      'icon': Icons.music_note_outlined,
      'category': 'Audio',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredResources = _allResources.where((resource) {
      final matchesSearch = resource['title'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == 'All' ||
          resource['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search resources...',
                  hintStyle: GoogleFonts.outfit(color: Colors.grey[400]),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey[400]),
                ),
                style: GoogleFonts.outfit(color: Colors.black87),
              ),
            ),
          ),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF8DBDBA),
                    labelStyle: GoogleFonts.outfit(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),

          // Resource List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: filteredResources.length,
              itemBuilder: (context, index) {
                final resource = filteredResources[index];
                return _buildResourceItem(
                  resource['title'],
                  '${resource['type']} • ${resource['duration']}',
                  resource['icon'],
                );
              },
            ),
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
