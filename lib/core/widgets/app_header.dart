import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../config/app_constants.dart';
import '../localization/app_localizations.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final String currentRoute;

  const AppHeader({
    super.key,
    required this.currentRoute,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final localeNotifier = ref.read(localeNotifierProvider.notifier);
    final isArabic = localeNotifier.isArabic;
    final screenWidth = MediaQuery.of(context).size.width;
    // Increased breakpoint to 1200 to ensure English navigation links never overflow or clip the menu button
    final isMobile = screenWidth < 1200;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.forestGreen,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Circular Restaurant Logo Image
              Expanded(
                child: InkWell(
                  onTap: () => context.go('/'),
                  borderRadius: BorderRadius.circular(24),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.figGold, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            AppConstants.logoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.figGold,
                                child: const Center(
                                  child: Text(
                                    'KT',
                                    style: TextStyle(
                                      color: AppColors.darkForest,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isArabic ? AppConstants.restaurantNameAr : AppConstants.restaurantNameEn,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                              Text(
                                isArabic ? AppConstants.locationAr : AppConstants.locationEn,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.figGold.withValues(alpha: 0.9),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Desktop Nav Links
              if (!isMobile) ...[
                _NavButton(
                  title: strings.navHome,
                  route: '/',
                  activeRoute: currentRoute,
                ),
                _NavButton(
                  title: strings.navMenu,
                  route: '/menu',
                  activeRoute: currentRoute,
                ),
                _NavButton(
                  title: strings.navGallery,
                  route: '/gallery',
                  activeRoute: currentRoute,
                ),
                _NavButton(
                  title: strings.navEvents,
                  route: '/events',
                  activeRoute: currentRoute,
                ),
                _NavButton(
                  title: strings.navContact,
                  route: '/contact',
                  activeRoute: currentRoute,
                ),
                const SizedBox(width: 8),

                // Clear Language Selector Button (indicating target language explicitly)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: AppColors.figGold.withValues(alpha: 0.6)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    localeNotifier.toggleLanguage();
                  },
                  icon: const Icon(Icons.language, size: 15, color: AppColors.figGold),
                  label: Text(
                    isArabic ? 'English' : 'العربية',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.5),
                  ),
                ),
                const SizedBox(width: 10),

                // Book Table Action CTA
                CustomButton(
                  text: strings.navBooking,
                  icon: Icons.calendar_today,
                  variant: ButtonVariant.primaryGold,
                  onPressed: () => context.go('/booking'),
                ),
              ] else ...[
                // Mobile Language Switch & Menu Drawer Button
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  ),
                  onPressed: () => localeNotifier.toggleLanguage(),
                  icon: const Icon(Icons.language, size: 16, color: AppColors.figGold),
                  label: Text(
                    isArabic ? 'EN' : 'عربي',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 26),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String title;
  final String route;
  final String activeRoute;

  const _NavButton({
    required this.title,
    required this.route,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: isActive ? AppColors.figGold : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
        onPressed: () => context.go(route),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 12.5,
                color: isActive ? AppColors.figGold : Colors.white,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 2,
                width: 14,
                color: AppColors.figGold,
              ),
          ],
        ),
      ),
    );
  }
}

class AppMobileDrawer extends ConsumerWidget {
  final String currentRoute;

  const AppMobileDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final localeNotifier = ref.read(localeNotifierProvider.notifier);
    final isArabic = localeNotifier.isArabic;

    return Drawer(
      backgroundColor: AppColors.darkForest,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.forestGreen,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? AppConstants.restaurantNameAr : AppConstants.restaurantNameEn,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isArabic ? AppConstants.locationAr : AppConstants.locationEn,
                          style: const TextStyle(
                            color: AppColors.figGold,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _DrawerTile(
              icon: Icons.home,
              title: strings.navHome,
              route: '/',
              isSelected: currentRoute == '/',
            ),
            _DrawerTile(
              icon: Icons.restaurant_menu,
              title: strings.navMenu,
              route: '/menu',
              isSelected: currentRoute == '/menu',
            ),
            _DrawerTile(
              icon: Icons.photo_library,
              title: strings.navGallery,
              route: '/gallery',
              isSelected: currentRoute == '/gallery',
            ),
            _DrawerTile(
              icon: Icons.event,
              title: strings.navEvents,
              route: '/events',
              isSelected: currentRoute == '/events',
            ),
            _DrawerTile(
              icon: Icons.contact_phone,
              title: strings.navContact,
              route: '/contact',
              isSelected: currentRoute == '/contact',
            ),
            _DrawerTile(
              icon: Icons.policy,
              title: strings.navTerms,
              route: '/terms',
              isSelected: currentRoute == '/terms',
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CustomButton(
                    text: strings.navBooking,
                    icon: Icons.calendar_today,
                    variant: ButtonVariant.primaryGold,
                    width: double.infinity,
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/booking');
                    },
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: AppColors.figGold),
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      localeNotifier.toggleLanguage();
                    },
                    icon: const Icon(Icons.language, color: AppColors.figGold, size: 16),
                    label: Text(
                      isArabic ? 'Switch to English' : 'التحويل إلى العربية',
                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final bool isSelected;

  const _DrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.figGold : Colors.white70,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.figGold : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.forestGreen.withValues(alpha: 0.5),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
