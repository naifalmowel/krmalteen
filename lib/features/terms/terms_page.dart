import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/responsive_container.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isArabic = strings.isArabic;

    return Column(
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
                    strings.navTerms,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic
                        ? 'سياسة الحجز والخصوصية لاستراحة ومطعم كرم التين'
                        : 'Booking Terms & Privacy Policy for Krm Alteen Restaurant',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.figGold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Content Card
          ResponsiveContainer(
            maxWidth: 900,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? '1. طبيعة طلب الحجز الإلكتروني' : '1. Electronic Reservation Request Policy',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isArabic
                          ? 'تعتبر طلبات الحجز المقدمة عبر الموقع الإلكتروني طلبات معلّقة (Pending) ولا تُعد حجزاً نهائياً ومؤكداً إلا بعد تواصل إدارة استراحة ومطعم كرم التين مع الزبون عبر الهاتف أو الواتساب لتأكيد توفر الطاولة في الموعد المطلوب.'
                          : 'Reservation requests submitted via the website are pending and do not guarantee final confirmation until management contacts the guest via phone or WhatsApp.',
                      style: const TextStyle(color: AppColors.deepCharcoal, fontSize: 14, height: 1.6),
                    ),
                    const Divider(height: 32),

                    Text(
                      isArabic ? '2. حماية وتأمين البيانات الشخصية' : '2. Data Protection & Privacy',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isArabic
                          ? 'نحن نلتزم بحماية كافة البيانات الشخصية التي يقدمها الزائر (مثل الاسم الكامل ورقم الهاتف) ونستخدمها حصراً لأغراض التواصل والتأكيد المتعلق بالحجز. لا يتم مشاركة هذه البيانات مع أي طرف ثالث تحت أي ظرف.'
                          : 'We are committed to protecting all personal data (such as name and phone number) exclusively for reservation confirmation and communication.',
                      style: const TextStyle(color: AppColors.deepCharcoal, fontSize: 14, height: 1.6),
                    ),
                    const Divider(height: 32),

                    Text(
                      isArabic ? '3. سياسة التعديل والإلغاء' : '3. Modification & Cancellation Policy',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isArabic
                          ? 'في حال رغبة الزبون بتعديل الموعد أو إلغاء طلب الحجز، يرجى التواصل معنا عبر الهاتف المباشر أو الواتساب على الرقم (+963997144071) قبل ساعتين على الأقل من موعد الحجز المحدد.'
                          : 'If you wish to modify or cancel your booking request, please notify us via WhatsApp or phone (+963997144071) at least 2 hours in advance.',
                      style: const TextStyle(color: AppColors.deepCharcoal, fontSize: 14, height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
  }
}
