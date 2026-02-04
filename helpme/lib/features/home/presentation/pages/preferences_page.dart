import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final List<String> _topics = [
    'ADD/ADHD',
    'Addiction/Substance Abuse',
    'Anxiety',
    'Death/Bereavement',
    'Depression',
    'Eating Disorder',
    'Financial/Money Issues',
    'Friends/Family Issues',
    'LGBTQIA+',
    'Loneliness',
    'Low Self-Esteem',
    'Marital/Relationship Issues',
    'OCD',
    'Physical Health Issues',
    'Pregnancy and Postpartum',
    'PTSD/Trauma',
    'School-related Stress',
    'Sleep Issues',
  ];

  final Set<String> _selectedTopics = {};

  void _toggleTopic(String topic) {
    setState(() {
      if (_selectedTopics.contains(topic)) {
        _selectedTopics.remove(topic);
      } else {
        _selectedTopics.add(topic);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedTopics.addAll(_topics);
    });
  }

  void _clearAll() {
    setState(() {
      _selectedTopics.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add your preferences',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Customize your space by choosing the topics that interest you the most. Selecting more topics will enhance your overall experience.',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: _selectAll,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFEBC137),
                            ), // Goldish color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: const Color(0xFFEBC137),
                          ),
                          child: Text(
                            'Select All',
                            style: GoogleFonts.outfit(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _clearAll,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFEBC137)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            foregroundColor: const Color(0xFFEBC137),
                          ),
                          child: Text('Clear', style: GoogleFonts.outfit()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.start,
                      children: _topics.map((topic) {
                        final isSelected = _selectedTopics.contains(topic);
                        return GestureDetector(
                          onTap: () => _toggleTopic(topic),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey[300]!,
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              topic,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey[700],
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to ExplorePage or just back
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFFC7C3E8,
                    ), // Light purple from reference
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
