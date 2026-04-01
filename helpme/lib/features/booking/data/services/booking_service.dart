import 'package:supabase_flutter/supabase_flutter.dart';

class BookingService {
  final _supabase = Supabase.instance.client;

  Future<void> bookAppointment({
    required String counselorName,
    required DateTime date,
    required String time,
  }) async {
    final user = _supabase.auth.currentUser;
    final userId = user?.id;
    final studentName = user?.userMetadata?['full_name'] ?? 'Anonymous Student';

    if (userId == null) throw Exception("User not logged in");

    // Retrieve counselor ID dynamically using the name
    final counselorData = await _supabase
        .from('counselors')
        .select('user_id')
        .eq('name', counselorName)
        .maybeSingle();

    final counselorId = counselorData?['user_id'];
    if (counselorId == null) throw Exception("Counselor not found");

    await _supabase.from('appointments').insert({
      'student_id': userId,
      'student_name': studentName,
      'counselor_id': counselorId,
      'counselor_name': counselorName,
      'appointment_date': date.toIso8601String().split('T')[0],
      'appointment_time': time,
      'status': 'pending',
    });
  }

  Future<List<Map<String, dynamic>>> getMyAppointments() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('appointments')
        .select()
        .eq('student_id', userId)
        .order('appointment_date', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getCounselorAppointments() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabase
        .from('appointments')
        .select()
        .eq('counselor_id', userId)
        .order('appointment_date', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updateAppointmentStatus(String id, String status) async {
    await _supabase
        .from('appointments')
        .update({'status': status})
        .eq('id', id);
  }

  Future<bool> isCounselor() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final response = await _supabase
        .from('counselors')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    return response != null;
  }
}
