import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpme/features/profile/presentation/pages/profile_page.dart';
import 'explore_page.dart';
import 'ai_chat_page.dart';
import 'breathing_page.dart';
import 'journaling_page.dart';
import 'meditation_page.dart';
import 'survey_page.dart';
import 'helpline_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _selectedMoodIndex = -1;

  final List<Map<String, dynamic>> _moods = [
    {'label': 'Happy', 'emoji': '😊'},
    {'label': 'Calm', 'emoji': '😌'},
    {'label': 'Sad', 'emoji': '😔'},
    {'label': 'Angry', 'emoji': '😠'},
    {'label': 'Anxious', 'emoji': '😰'},
    {'label': 'Tired', 'emoji': '😴'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic tools list defined in build to access context for navigation
    final List<Map<String, dynamic>> tools = [
      {
        'title': 'Breathing',
        'icon': Icons.spa_outlined,
        'bgColor': const Color(0xFFF5E6E0),
        'iconColor': const Color(0xFFCD9F8D),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BreathingPage()),
          );
        },
      },
      {
        'title': 'Journaling',
        'icon': Icons.edit_outlined,
        'bgColor': const Color(0xFFE0F2F1),
        'iconColor': const Color(0xFF8DBDBA),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JournalingPage()),
          );
        },
      },
      {
        'title': 'Meditation',
        'icon': Icons.self_improvement_outlined,
        'bgColor': const Color(0xFFFFF3E0),
        'iconColor': const Color(0xFFE6AD6C),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeditationPage()),
          );
        },
      },
      {
        'title': 'Survey',
        'icon': Icons.assignment_outlined,
        'bgColor': const Color(0xFFF3E5F5),
        'iconColor': const Color(0xFF9575CD),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SurveyPage(
                onComplete: (answers) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Survey Completed!')),
                  );
                },
              ),
            ),
          );
        },
      },
      {
        'title': 'Explore',
        'icon': Icons.explore_outlined,
        'bgColor': const Color(0xFFE8F5E9),
        'iconColor': const Color(0xFF43A047),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExplorePage()),
          );
        },
      },
      {
        'title': 'Help Line',
        'icon': Icons.phone_in_talk_outlined,
        'bgColor': const Color(0xFFFFEbee),
        'iconColor': const Color(0xFFE57373),
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpLinePage()),
          );
        },
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'How are you feeling?',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Color(0xFF8DBDBA),
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Mood Selector
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _moods.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final mood = _moods[index];
                      final isSelected = _selectedMoodIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMoodIndex = index;
                          });
                        },
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF8DBDBA)
                                    : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                mood['emoji'],
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mood['label'],
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF8DBDBA)
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                // AI First Aid Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8DBDBA),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8DBDBA).withOpacity(0.3),
                        blurRadius: 20,
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
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.support_agent,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'AI First Aid',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Talk to our interactive chatbot for instant coping support. It\'s safe and available 24/7.',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.95),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AiChatPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF8DBDBA),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Start a Conversation',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Quick Tools',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: tools.map((tool) {
                        final width = (constraints.maxWidth - 16) / 2;
                        return GestureDetector(
                          onTap: tool['onTap'] as VoidCallback?,
                          child: Container(
                            width: width,
                            height: 110,
                            decoration: BoxDecoration(
                              color: tool['bgColor'],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  tool['icon'],
                                  color: tool['iconColor'],
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tool['title'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: tool['iconColor'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
