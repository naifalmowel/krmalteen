import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/network_image_with_fallback.dart';
import '../../core/widgets/responsive_container.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  Future<void> _launchWhatsAppInquiry(BuildContext context, String eventType, bool isArabic) async {
    final message = isArabic
        ? 'مرحباً استراحة ومطعم كرم التين 🌿 أود الاستفسار عن حجز وتنظيم مناسبة ($eventType). يرجى تزويدي بالتفاصيل والأسعار المتاحة.'
        : 'Hello Krm Alteen Restaurant! I would like to inquire about organizing an event ($eventType). Please send me available packages and details.';

    final encoded = Uri.encodeComponent(message);
    final url = 'https://wa.me/${AppConstants.phoneWhatsApp}?text=$encoded';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isArabic = strings.isArabic;

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
                    strings.navEvents,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic
                        ? 'تنظيم الأعراس، حفلات الخطوبة، أعياد الميلاد، والاجتماعات العائلية في الهواء الجبلي النقي'
                        : 'Weddings, engagements, birthdays, and private family celebrations in mountain nature',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.figGold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Event Types Section
          ResponsiveContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
            child: Column(
              children: [
                _EventCard(
                  title: isArabic ? 'حفلات الزفاف والخطوبة الخارجية' : 'Outdoor Weddings & Engagements',
                  desc: isArabic
                      ? 'نوفر مساحات واسعة بين بساتين التين بإطلالات جبلية ساحرة مع تجهيز كامل للإضاءة، الطاولات، البوفيه المفتوح والمشاوي الشامية الفاخرة.'
                      : 'Spacious outdoor venue surrounded by fig orchards with open buffet, lighting, tables, and authentic Syrian barbecue.',
                  imageUrl: AppConstants.eventsWeddingUrl,
                  isArabic: isArabic,
                  onInquire: () => _launchWhatsAppInquiry(
                      context, isArabic ? 'حفل زفاف / خطوبة' : 'Wedding / Engagement', isArabic),
                ),
                const SizedBox(height: 32),
                _EventCard(
                  title: isArabic ? 'أعياد الميلاد والمناسبات الخاصة' : 'Birthdays & Private Parties',
                  desc: isArabic
                      ? 'احتفل بمناسبتك مع عائلتك وأصدقائك في أجواء هادئة وخاصة. نقدم كيكات مخصصة، عصائر طازجة، وضيافة شامية مميزة.'
                      : 'Celebrate with family and friends in cozy private seating. Custom cakes, fresh juices, and signature Syrian hospitality.',
                  imageUrl: AppConstants.eventsBirthdayUrl,
                  isArabic: isArabic,
                  onInquire: () => _launchWhatsAppInquiry(
                      context, isArabic ? 'عيد ميلاد / مناسبة خاصة' : 'Birthday Party', isArabic),
                ),
                const SizedBox(height: 32),
                _EventCard(
                  title: isArabic ? 'الاجتماعات والولائم العائلية الشتوية' : 'Cozy Winter Gatherings',
                  desc: isArabic
                      ? 'استمتع بدفء الصالة الشتوية المغلقة ومدفأة الحطب مع إطلالة على الجبال المكسوة بالثلج ولائم الخاروف المحشي والمشاوي.'
                      : 'Glass-enclosed lounge with firewood fireplace and mountain views, featuring stuffed lamb and charcoal grills.',
                  imageUrl: AppConstants.eventsFamilyGatheringUrl,
                  isArabic: isArabic,
                  onInquire: () => _launchWhatsAppInquiry(
                      context, isArabic ? 'وليمة عائلية شتوية' : 'Winter Gathering', isArabic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String desc;
  final String imageUrl;
  final bool isArabic;
  final VoidCallback onInquire;

  const _EventCard({
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.isArabic,
    required this.onInquire,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;

          final imageWidget = SizedBox(
            width: isWide ? 320 : double.infinity,
            height: isWide ? 240 : 200,
            child: NetworkImageWithFallback(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
          );

          final contentWidget = Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.forestGreen,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: isArabic ? 'استفسر عن حجز هذه المناسبة' : 'Inquire for Event Booking',
                  icon: Icons.chat_bubble_outline,
                  variant: ButtonVariant.primaryGold,
                  onPressed: onInquire,
                ),
              ],
            ),
          );

          if (isWide) {
            return Row(
              children: [
                imageWidget,
                Expanded(child: contentWidget),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageWidget,
                contentWidget,
              ],
            );
          }
        },
      ),
    );
  }
}
