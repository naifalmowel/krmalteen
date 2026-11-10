import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { ar, en }

final localeNotifierProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ar'));

  void setLocale(Locale locale) {
    state = locale;
  }

  void toggleLanguage() {
    if (state.languageCode == 'ar') {
      state = const Locale('en');
    } else {
      state = const Locale('ar');
    }
  }

  bool get isArabic => state.languageCode == 'ar';
}

class AppStrings {
  final String languageCode;

  AppStrings(this.languageCode);

  bool get isArabic => languageCode == 'ar';

  static AppStrings of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return AppStrings(locale.languageCode);
  }

  // Navigation
  String get navHome => isArabic ? 'الرئيسية' : 'Home';
  String get navMenu => isArabic ? 'قائمة الطعام' : 'Menu';
  String get navGallery => isArabic ? 'معرض الصور' : 'Gallery';
  String get navBooking => isArabic ? 'حجز طاولة' : 'Book a Table';
  String get navEvents => isArabic ? 'المناسبات والحفلات' : 'Events & Catering';
  String get navContact => isArabic ? 'اتصل بنا' : 'Contact Us';
  String get navTerms => isArabic ? 'الشروط والأحكام' : 'Terms & Privacy';

  // Hero Section
  String get heroTitle => isArabic
      ? 'أجواء جبلية ساحرة بين أشجار التين في الزبداني'
      : 'Charming Mountain Dining Among Fig Orchards in Zabadani';
  String get heroSubtitle => isArabic
      ? 'استمتع بإطلالات بانورامية على جبال الزبداني وبلودان، جلسات صيفية منعشة، وصالة شتوية دافئة مع مدفأة وأشهى المشاوي السورية الأصيلة.'
      : 'Enjoy panoramic views of Zabadani & Bloudan mountains, breezy outdoor summer seating, and a cozy winter glass lounge with fireplace and authentic Syrian grills.';
  String get bookTableNow => isArabic ? 'احجز طاولتك الآن' : 'Book Your Table Now';
  String get exploreMenu => isArabic ? 'استكشف قائمة الطعام' : 'Explore Our Menu';

  // Highlights
  String get highlightSummerTitle => isArabic ? 'جلسات صيفية في البساتين' : 'Outdoor Summer Orchards';
  String get highlightSummerDesc => isArabic
      ? 'تناول طعامك وسط أشجار التين المعمرة والهواء الجبلي النقي في منطقتنا النابوع.'
      : 'Dine among mature fig trees and fresh mountain breeze in Al Nabou.';

  String get highlightWinterTitle => isArabic ? 'صالة شتوية دافئة' : 'Cozy Winter Lounge';
  String get highlightWinterDesc => isArabic
      ? 'صالة زجاجية مغلقة ومجهزة بمدفأة حطب دافئة مع إطلالة جبلية ساحرة.'
      : 'Glass-enclosed lounge with firewood fireplace and mountain views.';

  String get highlightFoodTitle => isArabic ? 'مشاوي وأطباق سورية أصيلة' : 'Authentic Syrian Food';
  String get highlightFoodDesc => isArabic
      ? 'أجود أنواع اللحوم الطازجة، المقبلات الشامية المميزة، والعصائر المنعشة.'
      : 'Fresh local meats, signature Damascene mezze, and refreshing beverages.';

  String get highlightEventsTitle => isArabic ? 'أعراس ومناسبات خاصة' : 'Weddings & Private Gatherings';
  String get highlightEventsDesc => isArabic
      ? 'تنسيق كامل للحفلات والمناسبات العائلية في أجواء طبيعية لا تُنسى.'
      : 'Complete catering and organization for unforgettable outdoor celebrations.';

  // Booking Form
  String get bookingFormTitle => isArabic ? 'طلب حجز طاولة' : 'Table Reservation Request';
  String get bookingSubtitle => isArabic
      ? 'يرجى تعبئة النموذج أدناه. يرجى ملاحظة أن الحجز يعتبر معلّقاً لحين تأكيده من إدارتنا عبر الهاتف أو الواتساب.'
      : 'Please fill out the form below. Reservation is pending until confirmed by management via phone or WhatsApp.';

  String get customerName => isArabic ? 'الاسم الكامل' : 'Full Name';
  String get phone => isArabic ? 'رقم الهاتف / الواتساب' : 'Phone / WhatsApp';
  String get date => isArabic ? 'تاريخ الحجز' : 'Date';
  String get time => isArabic ? 'وقت الحجز' : 'Time';
  String get guests => isArabic ? 'عدد الضيوف' : 'Number of Guests';
  String get session => isArabic ? 'نوع الجلسة' : 'Seating Preference';
  String get sessionAny => isArabic ? 'اي مكان متاح' : 'Any available place';
  String get sessionSummer => isArabic ? 'جلسة صيفية خارجية (بين الأشجار)' : 'Summer Outdoor (Orchards)';
  String get sessionWinter => isArabic ? 'صالة شتوية مغلقة (مع مدفأة)' : 'Winter Glass Lounge (Fireplace)';
  String get occasion => isArabic ? 'المناسبة (اختياري)' : 'Occasion (Optional)';
  String get notes => isArabic ? 'ملاحظات إضافية' : 'Special Requests / Notes';
  String get submitBooking => isArabic ? 'إرسال طلب الحجز' : 'Submit Booking Request';

  // Status & Feedback
  String get submitting => isArabic ? 'جاري إرسال الطلب...' : 'Submitting request...';
  String get bookingSuccessTitle => isArabic ? 'تم استلام طلب الحجز بنجاح' : 'Booking Request Received!';
  String get bookingSuccessMsg => isArabic
      ? 'شكراً لك! تم تسجّيل طلب الحجز بالحالة المعلقة (قيد التأكيد). سنتواصل معك قريباً لتأكيد حجزك.'
      : 'Thank you! Your booking request is now pending confirmation. We will contact you shortly.';
  String get bookingFailTitle => isArabic ? 'تعذر إرسال الطلب مباشرة' : 'Direct Submission Failed';
  String get bookingFailMsg => isArabic
      ? 'حدث خطأ أثناء التواصل مع سيرفر الحجوزات. يمكنك متابعة الحجز عبر الواتساب مباشرة.'
      : 'Could not submit reservation. You can complete your booking via WhatsApp directly.';
  String get sendViaWhatsApp => isArabic ? 'تأكيد الحجز عبر الواتساب' : 'Confirm via WhatsApp';

  // Menu Categories
  String get catAll => isArabic ? 'الكل' : 'All';
  String get catGrills => isArabic ? 'المشاوي السورية' : 'Syrian Grills';
  String get catAppetizers => isArabic ? 'المقبلات الشامية' : 'Mezze & Appetizers';
  String get catMains => isArabic ? 'الأطباق الرئيسية' : 'Main Dishes';
  String get catDrinks => isArabic ? 'المشروبات والعصائر' : 'Drinks & Juices';
  String get catDesserts => isArabic ? 'الحلويات الشرقية' : 'Desserts & Sweets';

  // General & Contact
  String get contactUsTitle => isArabic ? 'تواصل معنا ومعلومات الموقع' : 'Contact Us & Location';
  String get callUs => isArabic ? 'اتصال مباشر' : 'Call Us';
  String get whatsappUs => isArabic ? 'محادثة واتساب' : 'WhatsApp Chat';
  String get emailUs => isArabic ? 'البريد الإلكتروني' : 'Email Us';
  String get addressTitle => isArabic ? 'العنوان والموقع' : 'Address & Location';
  String get openingHoursTitle => isArabic ? 'أوقات العمل' : 'Opening Hours';
  String get copyrights => isArabic
      ? 'جميع الحقوق محفوظة © استراحة ومطعم كرم التين'
      : 'All rights reserved © Krm Alteen Restaurant & Lounge';
}
