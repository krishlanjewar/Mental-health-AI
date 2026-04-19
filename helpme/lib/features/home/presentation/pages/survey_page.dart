import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveyQuestion {
  final String question;
  final List<String> options;
  final String category;

  SurveyQuestion({
    required this.question,
    required this.options,
    required this.category,
  });
}

class SurveyPage extends StatefulWidget {
  final Function(Map<String, String>) onComplete;

  const SurveyPage({super.key, required this.onComplete});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final List<SurveyQuestion> _questions = [
    SurveyQuestion(
      category: 'Academic Stress',
      question:
          'How overwhelmed do you feel by your current studies, exams, or upcoming deadlines?',
      options: ['Not at all', 'Slightly', 'Moderately', 'Extremely'],
    ),
    SurveyQuestion(
      category: 'Emotional State',
      question:
          'How would you describe your overall mood and motivation lately?',
      options: [
        'Very Positive',
        'Stable',
        'Low/Unmotivated',
        'Very Low/Depressed',
      ],
    ),
    SurveyQuestion(
      category: 'Sleep & Energy',
      question: 'How has your sleep and energy level been over the past week?',
      options: ['Great', 'Enough', 'Poor/Tired', 'Exhausted'],
    ),
    SurveyQuestion(
      category: 'Social Stress',
      question:
          'Are you experiencing any stress in your relationships or social life?',
      options: ['None', 'Minimal', 'Some conflict', 'Significant stress'],
    ),
    SurveyQuestion(
      category: 'Negative Events',
      question:
          'Have you recently faced any major setbacks (e.g., failure, breakup, conflict with faculty)?',
      options: [
        'No',
        'Something minor',
        'Yes, one event',
        'Yes, multiple events',
      ],
    ),
    SurveyQuestion(
      category: 'Coping Ability',
      question:
          'How confident do you feel in your ability to focus and cope with your current challenges?',
      options: ['Very Confident', 'Confident', 'Struggling', 'Cannot cope'],
    ),
  ];

  int _currentIndex = 0;
  final Map<String, String> _answers = {};

  void _nextQuestion(String answer) {
    _answers[_questions[_currentIndex].category] = answer;
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      widget.onComplete(_answers);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty || _currentIndex >= _questions.length) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0F7FA), // Very soft cyan
              Color(0xFFFFF8E1), // Warm gentle yellow/peach
              Color(0xFFE8F5E9), // Soft mint green
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return Stack(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          height: 10,
                          // Use FractionallySizedBox to animate width
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF80DEEA), Color(0xFF4DD0E1)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 48),
                Text(
                  'Help me understand you better',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: const Color(0xFF00838F),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      key: ValueKey<int>(_currentIndex),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A5F),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: question.options.length,
                            itemBuilder: (context, index) {
                              final option = question.options[index];
                              return _buildOptionCard(option, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String option, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.white.withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        elevation: 0,
        child: InkWell(
          onTap: () {
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted) _nextQuestion(option);
            });
          },
          borderRadius: BorderRadius.circular(24),
          splashColor: const Color(0xFF80DEEA).withOpacity(0.3),
          highlightColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF64B5F6).withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00838F).withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF006064),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    option,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2C3E50),
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFFB2EBF2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
