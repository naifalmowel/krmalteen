class AppValidators {
  static String? validateName(String? value, {bool isArabic = true}) {
    if (value == null || value.trim().isEmpty) {
      return isArabic ? 'يرجى إدخال الاسم الكامل' : 'Please enter your full name';
    }
    if (value.trim().length < 3) {
      return isArabic
          ? 'يجب أن يتكون الاسم من 3 أحرف على الأقل'
          : 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? validatePhone(String? value, {bool isArabic = true}) {
    if (value == null || value.trim().isEmpty) {
      return isArabic ? 'يرجى إدخال رقم الهاتف' : 'Please enter phone number';
    }
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanPhone.length < 8 || cleanPhone.length > 15) {
      return isArabic
          ? 'يرجى إدخال رقم هاتف صحيح (مثال: 0997144071 أو +963997144071)'
          : 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateGuests(String? value, {bool isArabic = true}) {
    if (value == null || value.trim().isEmpty) {
      return isArabic ? 'يرجى تحديد عدد الضيوف' : 'Please specify guest count';
    }
    final count = int.tryParse(value);
    if (count == null || count < 1) {
      return isArabic ? 'يجب أن يكون عدد الضيوف 1 على الأقل' : 'At least 1 guest required';
    }
    if (count > 100) {
      return isArabic
          ? 'للحجوزات الكبيرة أكثر من 100 شخص يرجى الاتصال بنا مباشرة'
          : 'For large parties (>100 guests), please contact us directly';
    }
    return null;
  }

  static String? validateDate(DateTime? date, {bool isArabic = true}) {
    if (date == null) {
      return isArabic ? 'يرجى اختيار تاريخ الحجز' : 'Please select booking date';
    }
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    if (date.isBefore(startOfToday)) {
      return isArabic ? 'لا يمكن اختيار تاريخ في الماضي' : 'Booking date cannot be in the past';
    }
    return null;
  }
}
