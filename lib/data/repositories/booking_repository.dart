import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/booking_model.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';

enum BookingSubmitResult {
  success,
  duplicate,
  offlineFallback,
  error,
}

class BookingSubmissionResponse {
  final BookingSubmitResult result;
  final String message;
  final BookingModel booking;

  BookingSubmissionResponse({
    required this.result,
    required this.message,
    required this.booking,
  });
}

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<BookingSubmissionResponse> submitBooking(BookingModel booking) async {
    // 1. Check idempotency / duplicate check locally
    final isDup = await LocalStorageService.isDuplicateRequest(booking.requestId);
    if (isDup) {
      return BookingSubmissionResponse(
        result: BookingSubmitResult.duplicate,
        message: 'تم إرسال هذا الطلب سابقاً وهو قيد المراجعة.',
        booking: booking,
      );
    }

    // Always cache locally first to protect customer input
    await LocalStorageService.saveSubmittedBooking(booking);

    // 2. Try Firestore submission if initialized
    final isFirebaseReady = await FirebaseService.initialize();
    if (!isFirebaseReady) {
      return BookingSubmissionResponse(
        result: BookingSubmitResult.offlineFallback,
        message: 'السيرفر غير متصل حالياً. يمكنك إرسال الطلب عبر الواتساب مباشرة.',
        booking: booking,
      );
    }

    try {
      // Validate or enforce status=pending
      final docRef = _firestore.collection('bookings').doc(booking.requestId);

      // Check if doc exists already in Firestore for idempotency
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        return BookingSubmissionResponse(
          result: BookingSubmitResult.duplicate,
          message: 'تم تسجيل هذا الحجز مسبقاً في السيرفر.',
          booking: booking,
        );
      }

      await docRef.set(booking.toMap());

      return BookingSubmissionResponse(
        result: BookingSubmitResult.success,
        message: 'تم إرسال طلب الحجز بنجاح وهو بالحالة المعلقة.',
        booking: booking,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Firestore booking submission error: $e');
      }
      return BookingSubmissionResponse(
        result: BookingSubmitResult.offlineFallback,
        message: 'تعذر الاتصال بالسيرفر. يرجى المتابعة عبر الواتساب لتأكيد حجزك.',
        booking: booking,
      );
    }
  }
}
