import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/live_google_map_widget.dart';
import '../../core/widgets/responsive_container.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildSocialButton(dynamic icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Tooltip(
        message: label,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.forestGreen,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.figGold),
          ),
          child: FaIcon(icon, color: AppColors.figGold, size: 18),
        ),
      ),
    );
  }

  Widget _buildContactCol1(
    BuildContext context,
    AppStrings strings,
    bool isArabic,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'قنوات الاتصال المباشر' : 'Direct Contact Channels',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isArabic
              ? 'انقر على أي وسيلة اتصال لتبدأ التواصل فوراً'
              : 'Tap any channel to reach us instantly',
          style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
        ),
        const SizedBox(height: 24),

        _ContactTile(
          icon: Icons.phone_in_talk,
          title: strings.callUs,
          subtitle: AppConstants.phoneDisplay,
          onTap: () => _launchUrl('tel:${AppConstants.phoneRaw}'),
        ),
        const SizedBox(height: 16),

        _ContactTile(
          icon: Icons.chat,
          title: strings.whatsappUs,
          subtitle: AppConstants.phoneDisplay,
          onTap: () =>
              _launchUrl('https://wa.me/${AppConstants.phoneWhatsApp}'),
        ),
        const SizedBox(height: 16),

        _ContactTile(
          icon: Icons.email_outlined,
          title: strings.emailUs,
          subtitle: AppConstants.email,
          onTap: () => _launchUrl('mailto:${AppConstants.email}'),
        ),
        const SizedBox(height: 32),

        // Social Media Section (Icons only next to each other)
        Text(
          isArabic ? 'تابعنا على منصات التواصل' : 'Follow Us on Social Media',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.forestGreen,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSocialButton(
                FontAwesomeIcons.facebook,
                'Facebook',
                () => _launchUrl(AppConstants.facebookUrl),
              ),
              _buildSocialButton(
                FontAwesomeIcons.instagram,
                'Instagram',
                () => _launchUrl(AppConstants.instagramUrl),
              ),
              _buildSocialButton(
                FontAwesomeIcons.whatsapp,
                'WhatsApp',
                () => _launchUrl(AppConstants.whatsappUrl),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactCol2(
    BuildContext context,
    AppStrings strings,
    bool isArabic,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: AppColors.forestGreen,
                size: 26,
              ),
              const SizedBox(width: 10),
              Text(
                strings.addressTitle,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.forestGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isArabic ? AppConstants.locationAr : AppConstants.locationEn,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: AppColors.deepCharcoal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'المنطقة الجبلية في النابوع - الزبداني، ريف دمشق. يتوفر كراج واسع ومجاني لسيارات الزوار.'
                : 'Mountain area of Al Nabou, Zabadani. Free spacious parking available.',
            style: const TextStyle(
              color: AppColors.mutedText,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          LiveGoogleMapWidget(height: 300),
          const Divider(height: 36),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: AppColors.forestGreen,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                strings.openingHoursTitle,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.forestGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            isArabic
                ? AppConstants.openingHoursAr
                : AppConstants.openingHoursEn,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.deepCharcoal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isArabic = strings.isArabic;

    return Column(
      children: [
        // Professional Luxury Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 20),
          color: AppColors.darkForest,
          child: ResponsiveContainer(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.figGold.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.figGold),
                  ),
                  child: Text(
                    isArabic ? 'تواصل معنا' : 'Get in Touch',
                    style: const TextStyle(
                      color: AppColors.figGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  strings.navContact,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Text(
                    isArabic
                        ? 'نحن هنا بخدمتكم دائماً. يسعدنا تواصلكم واستقبال حجز طاولتكم للاستمتاع بأجواء النابوع الساحرة'
                        : 'We are always at your service. Contact us to reserve your table and enjoy charming Al Nabou vibes.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.softCream,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Contact Details & Map Section
        ResponsiveContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 64),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildContactCol1(context, strings, isArabic),
                        ),
                        const SizedBox(width: 40),
                        Expanded(
                          child: _buildContactCol2(context, strings, isArabic),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildContactCol1(context, strings, isArabic),
                        const SizedBox(height: 40),
                        _buildContactCol2(context, strings, isArabic),
                      ],
                    );
            },
          ),
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.figGold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.forestGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.figGold, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepCharcoal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: AppColors.mutedText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
