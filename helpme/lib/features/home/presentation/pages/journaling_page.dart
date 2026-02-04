import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class JournalingPage extends StatelessWidget {
  const JournalingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      appBar: AppBar(
        title: Text(
          'My Journal',
          style: GoogleFonts.outfit(color: const Color(0xFF00695C)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: const Color(0xFF00695C)),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('journal').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No journal entries yet.\nStart writing today!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          // Convert box values to list and sort by date (newest first)
          final entries = box.values.toList().cast<Map>();
          // Assuming keys are int (auto-increment) or we store IDs.
          // Actually Hive boxes are maps. We can just reverse the values for chronological if added sequentially.
          // Better: Sort by date field.
          entries.sort(
            (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
          );

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: entries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final date = entry['date'] as DateTime;
              final text = entry['text'] as String;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMd().add_jm().format(date),
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      text,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WriteJournalPage()),
          );
        },
        backgroundColor: const Color(0xFF00695C),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(
          'New Entry',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class WriteJournalPage extends StatefulWidget {
  const WriteJournalPage({super.key});

  @override
  State<WriteJournalPage> createState() => _WriteJournalPageState();
}

class _WriteJournalPageState extends State<WriteJournalPage> {
  final TextEditingController _controller = TextEditingController();

  void _saveEntry() {
    if (_controller.text.trim().isEmpty) return;

    final box = Hive.box('journal');
    box.add({'text': _controller.text.trim(), 'date': DateTime.now()});

    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Journal entry saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      appBar: AppBar(
        title: Text(
          'New Entry',
          style: GoogleFonts.outfit(color: const Color(0xFF00695C)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: const Color(0xFF00695C)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
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
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Write your thoughts here...',
                    hintStyle: GoogleFonts.outfit(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  style: GoogleFonts.outfit(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00695C),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Save Entry',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
