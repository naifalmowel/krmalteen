import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/responsive_container.dart';
import '../../data/models/booking_model.dart';
import '../../data/providers/app_providers.dart';
import '../../data/repositories/booking_repository.dart';

class BookingPage extends ConsumerStatefulWidget {
  const BookingPage({super.key});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _guestsController = TextEditingController(text: '4');
  final _occasionController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0); // 2:00 PM
  String _selectedSession = 'any'; // 'summer' or 'winter'

  late String _currentRequestId;

  @override
  void initState() {
    super.initState();
    _generateNewRequestId();
  }

  void _generateNewRequestId() {
    final now = DateTime.now();
    _currentRequestId = 'req_${now.millisecondsSinceEpoch}_${now.microsecondsSinceEpoch % 1000}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _guestsController.dispose();
    _occasionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.forestGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.deepCharcoal,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _launchWhatsApp(BookingModel booking, bool isArabic) async {
    final formattedDate = AppFormatters.formatDate(booking.dateTime, isArabic: isArabic);
    final formattedTime = AppFormatters.formatTime(booking.dateTime, isArabic: isArabic);
    final message = isArabic
        ? 'مرحباً استراحة ومطعم كرم التين 🌿 أرغب بتأكيد حجز طاولة:\n\n👤 الاسم: ${booking.customerName}\n📞 الهاتف: ${booking.phone}\n👥 عدد الضيوف: ${booking.guests}\n📅 التاريخ: $formattedDate\n⏰ الوقت: $formattedTime\n🌿 نوع الجلسة: ${booking.session == 'summer' ? 'صيفية خارجية' : 'شتوية زجاجية'}\n${booking.occasion != null && booking.occasion!.isNotEmpty ? '🎉 المناسبة: ${booking.occasion}\n' : ''}${booking.notes != null && booking.notes!.isNotEmpty ? '📝 ملاحظات: ${booking.notes}\n' : ''}\nمعرف الطلب: ${booking.requestId}'
        : 'Hello Krm Alteen Restaurant! I would like to confirm my table reservation:\n\n👤 Name: ${booking.customerName}\n📞 Phone: ${booking.phone}\n👥 Guests: ${booking.guests}\n📅 Date: $formattedDate\n⏰ Time: $formattedTime\n🌿 Seating: ${booking.session}\nRequest ID: ${booking.requestId}';

    final encoded = Uri.encodeComponent(message);
    final url = 'https://wa.me/${AppConstants.phoneWhatsApp}?text=$encoded';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showSuccessDialog(BookingModel booking, bool isArabic) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.successGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Text(stringsOf(context).bookingSuccessTitle),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stringsOf(context).bookingSuccessMsg,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.softCream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ${isArabic ? "التاريخ" : "Date"}: ${DateFormat('yyyy/MM/dd').format(booking.dateTime)}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      '• ${isArabic ? "عدد الضيوف" : "Guests"}: ${booking.guests} ${isArabic ? "شخص" : "guests"}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      '• ${isArabic ? "الحالة" : "Status"}: ${isArabic ? "معلّق (بانتظار تأكيد الإدارة)" : "Pending Confirmation"}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: AppColors.warningOrange, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isArabic
                    ? 'ملاحظة مهمة: الحجز لا يُعد مؤكداً حتى يتم التواصل معك من قِبل إدارة المطعم عبر الهاتف أو الواتساب.'
                    : 'Important: Reservation is not confirmed until management verifies availability with you.',
                style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _nameController.clear();
                _phoneController.clear();
                _notesController.clear();
                _occasionController.clear();
              },
              child: Text(isArabic ? 'حسناً' : 'OK'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _launchWhatsApp(booking, isArabic);
              },
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: Text(isArabic ? 'إرسال نسخة للواتساب' : 'Send WhatsApp Copy'),
            ),
          ],
        );
      },
    );
  }

  void _showDuplicateDialog(String message, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isArabic ? 'تنبيه حجز مكرر' : 'Duplicate Request'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isArabic ? 'موافق' : 'OK'),
            ),
          ],
        );
      },
    );
  }

  void _showOfflineFallbackDialog(BookingModel booking, String message, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.wifi_off, color: AppColors.warningOrange, size: 26),
              const SizedBox(width: 8),
              Text(isArabic ? 'تأكيد الحجز عبر الواتساب' : 'WhatsApp Fallback'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Text(
                isArabic
                    ? 'تم حفظ تفاصيل حجزك محلياً. اضغط على الزر أدناه لإرسال ملخص الحجز مباشرة إلى واتساب مطعم كرم التين.'
                    : 'Your details are saved. Click below to send a prefilled booking summary via WhatsApp.',
                style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isArabic ? 'إلغاء' : 'Cancel'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _launchWhatsApp(booking, isArabic);
              },
              icon: const Icon(Icons.chat),
              label: Text(isArabic ? 'فتح الواتساب ومتابعة الحجز' : 'Open WhatsApp'),
            ),
          ],
        );
      },
    );
  }

  AppStrings stringsOf(BuildContext context) => AppStrings.of(context);

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isArabic = strings.isArabic;
    final bookingState = ref.watch(bookingNotifierProvider);
    final adminSettingsAsync = ref.watch(adminSettingsStreamProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
            color: AppColors.darkForest,
            child: ResponsiveContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Text(
                    strings.bookingFormTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Text(
                      strings.bookingSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.figGold,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Check if booking is disabled in admin_settings/config
          adminSettingsAsync.when(
            data: (settings) {
              if (!settings.isBookingEnabled) {
                return ResponsiveContainer(
                  maxWidth: 700,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 64),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(36),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.warningOrange.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.event_busy, color: AppColors.warningOrange, size: 48),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isArabic ? 'الحجوزات الإلكترونية متوقفة مؤقتاً' : 'Electronic Bookings Temporarily Paused',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepCharcoal,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isArabic
                                ? 'عذراً، استقبال الحجوزات الإلكترونية متوقف مؤقتاً بأمر الإدارة في الوقت الحالي. يمكنك التواصل معنا مباشرة عبر الواتساب أو الاتصال لحجز طاولتك الاستثنائية.'
                                : 'Sorry, electronic reservations are temporarily paused by management. You can contact us directly via WhatsApp or phone to book your table.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.mutedText,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 32),
                          CustomButton(
                            text: isArabic ? 'تواصل عبر الواتساب' : 'Contact via WhatsApp',
                            icon: Icons.chat,
                            variant: ButtonVariant.primaryGold,
                            onPressed: () async {
                              final url = 'https://wa.me/${settings.restaurantPhone}';
                              final uri = Uri.parse(url);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Normal Booking Form
              return ResponsiveContainer(
                maxWidth: 800,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Header
                          Row(
                            children: [
                              const Icon(Icons.event_seat, color: AppColors.forestGreen, size: 24),
                              const SizedBox(width: 10),
                              Text(
                                isArabic ? 'بيانات طلب الحجز' : 'Reservation Details',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 32),

                          // Name Field
                          Text(
                            strings.customerName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            validator: (v) => AppValidators.validateName(v, isArabic: isArabic),
                            decoration: InputDecoration(
                              hintText: isArabic ? 'أدخل اسمك الثلاثي' : 'Enter your full name',
                              prefixIcon: const Icon(Icons.person, color: AppColors.forestGreen),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Phone Field
                          Text(
                            strings.phone,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: (v) => AppValidators.validatePhone(v, isArabic: isArabic),
                            decoration: InputDecoration(
                              hintText: '+963 997 144 071',
                              prefixIcon: const Icon(Icons.phone, color: AppColors.forestGreen),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Guests & Session Row
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 600;

                              final guestsCol = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    strings.guests,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _guestsController,
                                    keyboardType: TextInputType.number,
                                    validator: (v) => AppValidators.validateGuests(v, isArabic: isArabic),
                                    decoration: InputDecoration(
                                      hintText: '4',
                                      prefixIcon: const Icon(Icons.group, color: AppColors.forestGreen),
                                    ),
                                  ),
                                ],
                              );

                              final sessionCol = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    strings.session,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedSession,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.nature, color: AppColors.forestGreen),
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'any',
                                        child: Text(strings.sessionAny),
                                      ),
                                      DropdownMenuItem(
                                        value: 'summer',
                                        child: Text(strings.sessionSummer),
                                      ),
                                      DropdownMenuItem(
                                        value: 'winter',
                                        child: Text(strings.sessionWinter),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          _selectedSession = val;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              );

                              return isWide
                                  ? Row(
                                      children: [
                                        Expanded(child: guestsCol),
                                        const SizedBox(width: 20),
                                        Expanded(child: sessionCol),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        guestsCol,
                                        const SizedBox(height: 20),
                                        sessionCol,
                                      ],
                                    );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Date & Time Row
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 600;

                              final dateCol = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    strings.date,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _selectDate(context),
                                    borderRadius: BorderRadius.circular(12),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.calendar_today, color: AppColors.forestGreen),
                                      ),
                                      child: Text(
                                        DateFormat('yyyy / MM / dd').format(_selectedDate),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              );

                              final timeCol = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    strings.time,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    onTap: () => _selectTime(context),
                                    borderRadius: BorderRadius.circular(12),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.access_time, color: AppColors.forestGreen),
                                      ),
                                      child: Text(
                                        _selectedTime.format(context),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              );

                              return isWide
                                  ? Row(
                                      children: [
                                        Expanded(child: dateCol),
                                        const SizedBox(width: 20),
                                        Expanded(child: timeCol),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        dateCol,
                                        const SizedBox(height: 20),
                                        timeCol,
                                      ],
                                    );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Occasion
                          Text(
                            strings.occasion,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _occasionController,
                            decoration: InputDecoration(
                              hintText: isArabic ? 'مثال: عيد ميلاد، ذكرى زواج...' : 'e.g. Birthday, Anniversary...',
                              prefixIcon: const Icon(Icons.celebration, color: AppColors.forestGreen),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Notes
                          Text(
                            strings.notes,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: isArabic ? 'أي طلبات خاصة أو ملاحظات للجلسة...' : 'Any special requests or notes...',
                              prefixIcon: const Icon(Icons.note, color: AppColors.forestGreen),
                            ),
                          ),
                          const SizedBox(height: 36),

                          // Submit Button
                          CustomButton(
                            text: strings.submitBooking,
                            icon: Icons.send,
                            variant: ButtonVariant.primaryGold,
                            width: double.infinity,
                            isLoading: bookingState.isLoading,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final finalDateTime = DateTime(
                                  _selectedDate.year,
                                  _selectedDate.month,
                                  _selectedDate.day,
                                  _selectedTime.hour,
                                  _selectedTime.minute,
                                );

                                final booking = BookingModel(
                                  requestId: _currentRequestId,
                                  customerName: _nameController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  dateTime: finalDateTime,
                                  session: _selectedSession,
                                  guests: int.tryParse(_guestsController.text.trim()) ?? 4,
                                  occasion: _occasionController.text.trim(),
                                  notes: _notesController.text.trim(),
                                  status: 'pending',
                                );

                                final result = await ref
                                    .read(bookingNotifierProvider.notifier)
                                    .submitBooking(booking);

                                if (!mounted) return;

                                if (result.result == BookingSubmitResult.success) {
                                  _showSuccessDialog(booking, isArabic);
                                } else if (result.result == BookingSubmitResult.duplicate) {
                                  _showDuplicateDialog(result.message, isArabic);
                                } else {
                                  _showOfflineFallbackDialog(booking, result.message, isArabic);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(64),
                child: CircularProgressIndicator(color: AppColors.figGold),
              ),
            ),
            error: (err, stack) => ResponsiveContainer(
              maxWidth: 800,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fallback form if settings stream errors
                        Row(
                          children: [
                            const Icon(Icons.event_seat, color: AppColors.forestGreen, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              isArabic ? 'بيانات طلب الحجز' : 'Reservation Details',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.forestGreen,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        // Name
                        Text(strings.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          validator: (v) => AppValidators.validateName(v, isArabic: isArabic),
                          decoration: InputDecoration(
                            hintText: isArabic ? 'أدخل اسمك الثلاثي' : 'Enter your full name',
                            prefixIcon: const Icon(Icons.person, color: AppColors.forestGreen),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Phone
                        Text(strings.phone, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (v) => AppValidators.validatePhone(v, isArabic: isArabic),
                          decoration: InputDecoration(
                            hintText: '+963 997 144 071',
                            prefixIcon: const Icon(Icons.phone, color: AppColors.forestGreen),
                          ),
                        ),
                        const SizedBox(height: 36),
                        CustomButton(
                          text: strings.submitBooking,
                          icon: Icons.send,
                          variant: ButtonVariant.primaryGold,
                          width: double.infinity,
                          isLoading: bookingState.isLoading,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
