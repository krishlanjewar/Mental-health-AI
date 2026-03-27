import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'preferences_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.grid_view},
    {'name': 'Sleep', 'icon': Icons.bed},
    {'name': 'Break the Silence', 'icon': Icons.record_voice_over},
    {'name': 'Lifestyle', 'icon': Icons.spa},
    {'name': 'Fitness & Nutrition', 'icon': Icons.fitness_center},
  ];

  final List<Map<String, dynamic>> _posts = [
    {
      'category': 'Mental Health and Wellness',
      'date': '15/01/2026',
      'author': 'Dr. Susma Sharma',
      'role': 'MD (Psychiatry)',
      'title':
          'Family Things Not to Talk About in Front of Kids: A Child Psychology Perspective',
      'snippet':
          'What is spoken at home shapes how children understand relationships, safety, self-worth, conflict, money, and even their place in the world...',
      'likes': 2,
      'comments': 0,
      'imageColor': Colors.grey[300], // Placeholder for image
    },
    {
      'category': 'Mental Health and Wellness',
      'date': '27/12/2025',
      'author': 'Dr Asha Gopalan',
      'role': 'Counselling Psychologist',
      'title':
          'Rediscovering Self-Worth: How Recovery Helps Addicts Believe in Themselves Again',
      'snippet': 'Addicts suffer from low self-esteem...',
      'likes': 2,
      'comments': 0,
      'imageColor': Colors.orange[100], // Placeholder for image
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Explore',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreferencesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Categories
          SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = index == _selectedCategoryIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(index),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          category['icon'],
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'],
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Content List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                final post = _posts[index];
                return _buildPostCard(post);
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF5D5B8C); // All - Purpleish
      case 1:
        return const Color(0xFFA5C860); // Sleep - Greenish
      case 2:
        return const Color(0xFFEBC137); // Break Silence - Yellowish
      case 3:
        return const Color(0xFF3DA9DC); // Lifestyle - Blueish
      case 4:
        return const Color(0xFFD87042); // Fitness - Reddish
      default:
        return Colors.grey;
    }
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.psychology,
                  color: Color(0xFFE65C62),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  post['category'],
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              post['date'],
              style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: post['imageColor'],
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: NetworkImage(
                'https://via.placeholder.com/400x200',
              ), // Placeholder
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Overlay for text readability if needed
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.3)],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${post['author']} • ',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        post['role'],
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title mostly visible on image in design, but let's put it below
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          post['title'],
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          post['snippet'],
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${post['likes']}',
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              '${post['comments']}',
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
