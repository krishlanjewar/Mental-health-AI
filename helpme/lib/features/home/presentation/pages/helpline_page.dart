import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpLinePage extends StatelessWidget {
  const HelpLinePage({super.key});

  final List<Map<String, String>> helplines = const [
    {
      'name': 'Tele-MANAS – Gov’t of India',
      'number': '14416',
      'alt_number': '1800-891-4416',
      'description': 'National Tele Mental Health Programme of India',
    },
    {
      'name': 'KIRAN Helpline',
      'number': '1800-599-0019',
      'description': 'National mental health rehabilitation helpline',
    },
    {
      'name': 'Vandrevala Foundation',
      'number': '1800-233-3330',
      'alt_number': '1860-266-2345',
      'description': 'Mental health support and crisis intervention',
    },
    {
      'name': 'Fortis Hospital National Helpline',
      'number': '+91-8376804102',
      'description': 'Psychological support in multiple languages',
    },
    {
      'name': 'AASRA',
      'number': '+91-9820466726',
      'description': 'Suicide prevention and distress helpline',
    },
    {
      'name': 'MPower',
      'number': '1800-120-820050',
      'description': 'Maharashtra & BMC initiative for mental health',
    },
    {
      'name': 'Regional Mental Hospital',
      'number': '+91-712-2583750',
      'description': 'Local support and psychiatric care',
    },
    {
      'name': 'Max Super Speciality Hospital',
      'number': '+91-712-7120000',
      'description': 'Specialized mental health support',
    },
    {
      'name': 'Wockhardt Hospital',
      'number': '+91-8605604444',
      'description': 'Emergency and psychiatric consultation',
    },
    {
      'name': 'Lifeskills Nashamukti Kendra',
      'number': '+91-7798888550',
      'description': 'De-addiction and rehabilitation center',
    },
  ];

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Remove all non-numeric characters except +
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Could not launch $launchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(
          'Emergency Help Lines',
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: helplines.length,
        itemBuilder: (context, index) {
          final helpline = helplines[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    helpline['name']!,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8DBDBA),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (helpline['description'] != null) ...[
                    Text(
                      helpline['description']!,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _makePhoneCall(helpline['number']!),
                          icon: const Icon(Icons.phone),
                          label: Text(helpline['number']!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8DBDBA),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      if (helpline['alt_number'] != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _makePhoneCall(helpline['alt_number']!),
                            icon: const Icon(Icons.phone),
                            label: Text(helpline['alt_number']!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8DBDBA),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
