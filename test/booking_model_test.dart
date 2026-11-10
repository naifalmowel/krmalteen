import 'package:flutter_test/flutter_test.dart';
import 'package:krm_alten/data/models/booking_model.dart';
import 'package:krm_alten/core/utils/formatters.dart';

void main() {
  group('BookingModel Serialization & Idempotency Tests', () {
    test('BookingModel toMap enforces status pending and correct fields', () {
      final now = DateTime(2026, 6, 15, 14, 30);
      final booking = BookingModel(
        requestId: 'req_123456',
        customerName: 'سامر أحمد',
        phone: '0997144071',
        dateTime: now,
        session: 'summer',
        guests: 4,
        occasion: 'حفل عائلي',
        notes: 'طاولة بجانب أشجار التين',
      );

      final map = booking.toMap();

      expect(map['requestId'], equals('req_123456'));
      expect(map['customerName'], equals('سامر أحمد'));
      expect(map['phone'], equals('0997144071'));
      expect(map['session'], equals('summer'));
      expect(map['guests'], equals(4));
      expect(map['status'], equals('pending')); // Public status must strictly be pending
      expect(map['source'], equals('web'));
    });

    test('WhatsApp URL builder formats message and encodes special characters correctly', () {
      final url = AppFormatters.buildWhatsAppUrl(
        phone: '963997144071',
        customerName: 'محمد خالد',
        bookingDate: '2026/06/15',
        bookingTime: '02:00 PM',
        guests: 5,
        session: 'جلسة صيفية بين الأشجار',
        occasion: 'عيد ميلاد',
        notes: 'كرسي أطفال',
      );

      expect(url, contains('https://wa.me/963997144071?text='));
      expect(url, contains('%D9%85%D8%AD%D9%85%D8%AF%20%D8%AE%D8%A7%D9%84%D8%AF')); // Encoded "محمد خالد"
    });
  });
}
