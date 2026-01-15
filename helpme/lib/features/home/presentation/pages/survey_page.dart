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
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                color: const Color(0xFF8DBDBA),
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 40),
              Text(
                'Help me understand you better',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: const Color(0xFF8DBDBA),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                question.question,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final option = question.options[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => _nextQuestion(option),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                option,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
