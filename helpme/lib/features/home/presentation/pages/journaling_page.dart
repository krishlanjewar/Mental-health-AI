import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class JournalingPage extends StatefulWidget {
  const JournalingPage({super.key});

  @override
  State<JournalingPage> createState() => _JournalingPageState();
}

class _JournalingPageState extends State<JournalingPage> {
  DateTime _selectedDate = DateTime.now();
  late Box _box;
  final TextEditingController _controller = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _box = Hive.box('journal');
    _loadEntry();
  }

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  String get _dateKey {
    return DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  void _loadEntry() {
    String text = '';
    if (_box.containsKey(_dateKey)) {
      final entry = _box.get(_dateKey);
      if (entry is Map) {
        text = entry['text'] as String? ?? '';
      } else if (entry is String) {
        text = entry;
      }
    } else {
      for (var value in _box.values) {
        if (value is Map && value['date'] is DateTime) {
          final date = value['date'] as DateTime;
          if (date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day) {
            text = value['text'] as String? ?? '';
            break;
          }
        }
      }
    }
    _controller.text = text;
    if (_isToday && text.trim().isEmpty) {
      _isEditing = true;
    } else {
      _isEditing = false;
    }
  }

  void _saveEntry(String text) {
    if (text.trim().isEmpty) {
      _box.delete(_dateKey);
    } else {
      _box.put(_dateKey, {
        'text': text,
        'date': _selectedDate,
      });
    }
  }

  @override
  void dispose() {
    if (_isToday) {
      _saveEntry(_controller.text);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMMd().format(_selectedDate),
          style: GoogleFonts.outfit(
            color: const Color(0xFF00695C),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF00695C)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Color(0xFF00695C)),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF00695C),
                        onPrimary: Colors.white,
                        onSurface: Color(0xFF00695C),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                if (_isToday) {
                  _saveEntry(_controller.text);
                }
                setState(() {
                  _selectedDate = picked;
                  _loadEntry();
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isToday ? "How are you feeling today?" : "Your feelings on this day",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  color: const Color(0xFF00695C),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00695C).withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: _isToday && _isEditing
                      ? Column(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: 'Dear Diary...\n\nWrite about the events of your day here...',
                                  hintStyle: GoogleFonts.outfit(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                ),
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  _saveEntry(_controller.text);
                                  setState(() {
                                    _isEditing = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00695C),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Finish Writing',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_isToday && !_isEditing)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  },
                                  icon: const Icon(Icons.edit, size: 20, color: Color(0xFF00695C)),
                                  label: Text(
                                    'Edit', 
                                    style: GoogleFonts.outfit(color: const Color(0xFF00695C), fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  _controller.text.trim().isEmpty
                                      ? 'No diary entry for this date.'
                                      : _controller.text,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    height: 1.6,
                                    color: _controller.text.trim().isEmpty
                                        ? Colors.grey[400]
                                        : Colors.black87,
                                    fontStyle: _controller.text.trim().isEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                ),
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
    );
  }
}
