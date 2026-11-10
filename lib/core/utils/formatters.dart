import 'package:intl/intl.dart';

class AppFormatters {
  static String formatCurrency(double amount, {bool isArabic = true}) {
    final formatter = NumberFormat('#,###', isArabic ? 'ar' : 'en');
    final formatted = formatter.format(amount);
    return isArabic ? '$formatted ل.س' : '$formatted SYP';
  }

  static String formatDate(DateTime dateTime, {bool isArabic = true}) {
    final formatter = DateFormat('yyyy/MM/dd - EEEE', isArabic ? 'ar' : 'en');
    return formatter.format(dateTime);
  }

  static String formatTime(DateTime dateTime, {bool isArabic = true}) {
    final formatter = DateFormat('hh:mm a', isArabic ? 'ar' : 'en');
    return formatter.format(dateTime);
  }

  static String buildWhatsAppUrl({
    required String phone,
    required String customerName,
    required String bookingDate,
    required String bookingTime,
    required int guests,
    required String session,
    String? occasion,
    String? notes,
  }) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    final targetPhone = cleanPhone.startsWith('0')
        ? '963${cleanPhone.substring(1)}'
        : (cleanPhone.startsWith('963') ? cleanPhone : '963$cleanPhone');

    final messageBuffer = StringBuffer();
    messageBuffer.writeln('مرحباً استراحة ومطعم كرم التين 🌿');
    messageBuffer.writeln('أود تقديم طلب حجز طاولة بالتفاصيل التالية:');
    messageBuffer.writeln('• الاسم: $customerName');
    messageBuffer.writeln('• التاريخ: $bookingDate');
    messageBuffer.writeln('• الوقت: $bookingTime');
    messageBuffer.writeln('• عدد الضيوف: $guests شخص');
    messageBuffer.writeln('• الجلسة المفضلّة: $session');
    if (occasion != null && occasion.trim().isNotEmpty) {
      messageBuffer.writeln('• المناسبة: $occasion');
    }
    if (notes != null && notes.trim().isNotEmpty) {
      messageBuffer.writeln('• ملاحظات: $notes');
    }
    messageBuffer.writeln('بانتظار تأكيد الحجز من قبلكم. شكراً جزيلاً!');

    final encodedMessage = Uri.encodeComponent(messageBuffer.toString());
    return 'https://wa.me/$targetPhone?text=$encodedMessage';
  }
}
