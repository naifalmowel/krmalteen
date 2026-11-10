import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_model.dart';

class LocalStorageService {
  static const String _submittedBookingsKey = 'krm_submitted_bookings';

  static Future<void> saveSubmittedBooking(BookingModel booking) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing = prefs.getStringList(_submittedBookingsKey) ?? [];
      final data = {
        'requestId': booking.requestId,
        'customerName': booking.customerName,
        'phone': booking.phone,
        'dateTime': booking.dateTime.toIso8601String(),
        'session': booking.session,
        'guests': booking.guests,
        'occasion': booking.occasion,
        'notes': booking.notes,
        'status': booking.status,
        'createdAt': booking.createdAt.toIso8601String(),
      };
      existing.add(jsonEncode(data));
      await prefs.setStringList(_submittedBookingsKey, existing);
    } catch (_) {}
  }

  static Future<bool> isDuplicateRequest(String requestId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> existing = prefs.getStringList(_submittedBookingsKey) ?? [];
      for (final item in existing) {
        final decoded = jsonDecode(item) as Map<String, dynamic>;
        if (decoded['requestId'] == requestId) {
          return true;
        }
      }
    } catch (_) {}
    return false;
  }
}
