import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E6E0),
      appBar: AppBar(
        title: Text(
          'Breathing Exercise',
          style: GoogleFonts.outfit(color: const Color(0xFF8D6E63)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: const Color(0xFF8D6E63)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFCD9F8D).withValues(alpha: 0.4),
                          const Color(0xFFCD9F8D).withValues(alpha: 0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFCD9F8D).withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _controller.status == AnimationStatus.forward
                            ? 'Inhale'
                            : 'Exhale',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
            Text(
              'Focus on your breath',
              style: GoogleFonts.outfit(
                fontSize: 18,
                color: const Color(0xFF8D6E63),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
