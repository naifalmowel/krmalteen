import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String requestId;
  final String customerName;
  final String phone;
  final DateTime dateTime;
  final String session; // 'summer' or 'winter'
  final int guests;
  final String? occasion;
  final String? notes;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final DateTime createdAt;
  final String source; // 'web'

  BookingModel({
    required this.requestId,
    required this.customerName,
    required this.phone,
    required this.dateTime,
    required this.session,
    required this.guests,
    this.occasion,
    this.notes,
    this.status = 'pending',
    DateTime? createdAt,
    this.source = 'web',
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'id': requestId,
      'customerName': customerName,
      'fullName': customerName,
      'phone': phone,
      'dateTime': Timestamp.fromDate(dateTime),
      'bookingDate': dateTime.toIso8601String().split('T').first,
      'bookingTime': '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
      'session': session,
      'seatingPreference': session,
      'guests': guests,
      'guestsCount': guests,
      'occasion': occasion ?? '',
      'notes': notes ?? '',
      'specialRequests': notes ?? '',
      'status': 'pending', // Public client always creates with 'pending' status
      'createdAt': FieldValue.serverTimestamp(),
      'source': source,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return BookingModel(
      requestId: map['requestId'] ?? map['id'] ?? id,
      customerName: map['customerName'] ?? map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      dateTime: parseDate(map['dateTime'] ?? map['bookingDate']),
      session: map['session'] ?? map['seatingPreference'] ?? 'summer',
      guests: (map['guests'] as num?)?.toInt() ?? (map['guestsCount'] as num?)?.toInt() ?? 1,
      occasion: map['occasion'] as String?,
      notes: map['notes'] as String? ?? map['specialRequests'] as String?,
      status: map['status'] ?? 'pending',
      createdAt: parseDate(map['createdAt']),
      source: map['source'] ?? 'web',
    );
  }
}
