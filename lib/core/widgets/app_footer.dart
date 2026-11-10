import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_constants.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildSocialIcon(dynamic icon, String platform, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Tooltip(
        message: platform,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.forestGreen,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.figGold.withValues(alpha: 0.5),
            ),
          ),
          child: Center(
            child: FaIcon(
              icon,
              color: AppColors.figGold,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isArabic = strings.isArabic;

    return Container(
      color: AppColors.darkForest,
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.figGold, AppColors.warmGold, AppColors.amberGold],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 850;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Col 1: Brand Info & Social Icons
                    SizedBox(
                      width: isWide ? 320 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.figGold, width: 1.5),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    AppConstants.logoUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                isArabic ? AppConstants.restaurantNameAr : AppConstants.restaurantNameEn,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isArabic ? AppConstants.taglineAr : AppConstants.taglineEn,
                            textAlign: isWide ? TextAlign.start : TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.lightMutedText,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Social Media Row
                          Row(
                            mainAxisAlignment: isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
                            children: [
                              _buildSocialIcon(
                                FontAwesomeIcons.facebook,
                                'Facebook',
                                () => _launchUrl(AppConstants.facebookUrl),
                              ),
                              const SizedBox(width: 12),
                              _buildSocialIcon(
                                FontAwesomeIcons.instagram,
                                'Instagram',
                                () => _launchUrl(AppConstants.instagramUrl),
                              ),
                              const SizedBox(width: 12),
                              _buildSocialIcon(
                                FontAwesomeIcons.whatsapp,
                                'WhatsApp',
                                () => _launchUrl('https://wa.me/${AppConstants.phoneWhatsApp}'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (!isWide) const SizedBox(height: 32),

                    // Col 2: Navigation Links
                    Column(
                      crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        Text(
                          isArabic ? 'روابط سريعة' : 'Quick Links',
                          style: const TextStyle(
                            color: AppColors.figGold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _FooterLink(text: strings.navHome, onTap: () => context.go('/')),
                        _FooterLink(text: strings.navMenu, onTap: () => context.go('/menu')),
                        _FooterLink(text: strings.navGallery, onTap: () => context.go('/gallery')),
                        _FooterLink(text: strings.navBooking, onTap: () => context.go('/booking')),
                        _FooterLink(text: strings.navEvents, onTap: () => context.go('/events')),
                        _FooterLink(text: strings.navTerms, onTap: () => context.go('/terms')),
                      ],
                    ),

                    if (!isWide) const SizedBox(height: 32),

                    // Col 3: Contact & Location (With LTR Direction for Phone Numbers)
                    Column(
                      crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        Text(
                          isArabic ? 'معلومات التواصل' : 'Contact Details',
                          style: const TextStyle(
                            color: AppColors.figGold,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _FooterContactItem(
                          icon: Icons.phone,
                          text: AppConstants.phoneDisplay,
                          onTap: () => _launchUrl('tel:${AppConstants.phoneRaw}'),
                        ),
                        _FooterContactItem(
                          icon: Icons.chat_bubble_outline,
                          text: '${AppConstants.phoneDisplay} (واتساب)',
                          onTap: () => _launchUrl('https://wa.me/${AppConstants.phoneWhatsApp}'),
                        ),
                        _FooterContactItem(
                          icon: Icons.email_outlined,
                          text: AppConstants.email,
                          onTap: () => _launchUrl('mailto:${AppConstants.email}'),
                        ),
                        _FooterContactItem(
                          icon: Icons.location_on_outlined,
                          text: isArabic ? AppConstants.locationAr : AppConstants.locationEn,
                          onTap: () => _launchUrl(AppConstants.googleMapsUrl),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          const Divider(color: Colors.white12, height: 1),

          // Copyright Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              strings.copyrights,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.lightMutedText,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _FooterContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _FooterContactItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.figGold),
            const SizedBox(width: 8),
            // Enforce LTR direction for phone numbers and emails
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
