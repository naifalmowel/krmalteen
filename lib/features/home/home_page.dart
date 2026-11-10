import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/config/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/live_google_map_widget.dart';
import '../../core/widgets/network_image_with_fallback.dart';
import '../../core/widgets/responsive_container.dart';
import '../../data/models/menu_item_model.dart';
import '../../data/providers/app_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppStrings.of(context);
    final isArabic = strings.isArabic;
    final menuAsync = ref.watch(menuStreamProvider);

    return Column(
      children: [
        // 1. Full-Bleed Hero Section (uses cover_web.webp for Desktop Web & hero.webp for Mobile)
        _buildHeroSection(context, strings, isArabic),

        // 2. Quick Info & Highlights Bar
        _buildHighlightsSection(context, strings, isArabic),

        // 3. Seasonal Experiences (Summer Orchards vs Winter Lounge)
        _buildSeasonalExperiencesSection(context, strings, isArabic),

        // 4. Featured Menu Preview
        _buildFeaturedMenuSection(context, strings, isArabic, menuAsync),

        // 5. Gallery Preview
        _buildGalleryPreviewSection(context, strings, isArabic, ref),

        // 6. Location & Live Google Maps Section
        _buildLocationSection(context, strings, isArabic),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, AppStrings strings, bool isArabic) {
    final screenHeight = MediaQuery.of(context).size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        final heroImage = isDesktop ? AppConstants.heroWebBannerUrl : AppConstants.heroBannerUrl;
        final heroHeight = isDesktop ? (screenHeight * 0.82).clamp(580, 780) : (screenHeight * 0.75).clamp(520, 700);

        return Stack(
          children: [
            // Background Image (cover_web.webp on Web Desktop / hero.webp on Mobile)
            SizedBox(
              height: heroHeight.toDouble(),
              width: double.infinity,
              child: NetworkImageWithFallback(
                imageUrl: heroImage,
                fit: BoxFit.cover,
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(begin: const Offset(1.04, 1.04), end: const Offset(1, 1), duration: 2200.ms, curve: Curves.easeOutCubic),

            // Gradient Dark Overlay for Crystal Clear Text Contrast
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.darkForest.withValues(alpha: 0.65),
                      AppColors.darkForest.withValues(alpha: 0.88),
                    ],
                  ),
                ),
              ),
            ),

            // Text & CTA Overlay Content
            Positioned.fill(
              child: ResponsiveContainer(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                    children: [
                      // Location Badge with Circular Logo
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.figGold.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: AppColors.figGold),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.figGold.withValues(alpha: 0.25),
                              blurRadius: 14,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(AppConstants.logoUrl, fit: BoxFit.cover),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isArabic ? 'الزبداني - النابوع' : 'Zabadani - Al Nabou',
                              style: const TextStyle(
                                color: AppColors.warmGold,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: -0.3, end: 0, curve: Curves.easeOutBack)
                          .then()
                          .shimmer(duration: 1800.ms, color: AppColors.figGold.withValues(alpha: 0.4)),
                      const SizedBox(height: 24),

                      // Main Title
                      Text(
                        strings.heroTitle,
                        textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isDesktop ? 40 : 28,
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                          letterSpacing: -0.5,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 800.ms)
                          .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                      const SizedBox(height: 16),

                      // Subtitle
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: Text(
                          strings.heroSubtitle,
                          textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                          style: TextStyle(
                            color: AppColors.softCream,
                            fontSize: isDesktop ? 17 : 15.5,
                            height: 1.65,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 800.ms)
                          .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                      const SizedBox(height: 36),

                      // Action CTA Buttons
                      Wrap(
                        alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          CustomButton(
                            text: strings.bookTableNow,
                            icon: Icons.calendar_month,
                            variant: ButtonVariant.primaryGold,
                            onPressed: () => context.go('/booking'),
                          ),
                          CustomButton(
                            text: strings.exploreMenu,
                            icon: Icons.restaurant_menu,
                            variant: ButtonVariant.outlineLight,
                            onPressed: () => context.go('/menu'),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(delay: 600.ms, duration: 800.ms)
                          .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1), curve: Curves.easeOutBack),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHighlightsSection(BuildContext context, AppStrings strings, bool isArabic) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveContainer(
        child: Column(
          children: [
            Text(
              isArabic ? 'لماذا تختار كرم التين؟' : 'Why Visit Krm Alteen?',
              style: const TextStyle(
                color: AppColors.forestGreen,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
            const SizedBox(height: 8),
            Container(
              height: 3,
              width: 60,
              color: AppColors.figGold,
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .scaleX(begin: 0, end: 1, curve: Curves.easeOutQuad),
            const SizedBox(height: 40),

            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                final cards = [
                  _HighlightCard(
                    icon: Icons.nature_people,
                    title: strings.highlightSummerTitle,
                    desc: strings.highlightSummerDesc,
                    bgImageUrl: 'assets/images/summer.webp',
                  ),
                  _HighlightCard(
                    icon: Icons.fireplace,
                    title: strings.highlightWinterTitle,
                    desc: strings.highlightWinterDesc,
                    bgImageUrl: 'assets/images/in.webp',
                  ),
                  _HighlightCard(
                    icon: Icons.kebab_dining,
                    title: strings.highlightFoodTitle,
                    desc: strings.highlightFoodDesc,
                    bgImageUrl: 'assets/images/mael.webp',
                  ),
                  _HighlightCard(
                    icon: Icons.celebration,
                    title: strings.highlightEventsTitle,
                    desc: strings.highlightEventsDesc,
                    bgImageUrl: 'assets/images/3ors.webp',
                  ),
                ];

                return GridView.count(
                  crossAxisCount: isWide ? 4 : (constraints.maxWidth > 500 ? 2 : 1),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: isWide ? 0.7 : 1.5,
                  children: List.generate(cards.length, (index) {
                    final delayMs = 100 + (index * 150);
                    return cards[index]
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: delayMs), duration: 600.ms)
                        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad)
                        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonalExperiencesSection(
      BuildContext context, AppStrings strings, bool isArabic) {
    return Container(
      color: AppColors.softCream,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveContainer(
        child: Column(
          children: [
            Text(
              isArabic ? 'تجربتان ساحرتان في قلب الطبيعة' : 'Two Magical Seasonal Experiences',
              style: const TextStyle(
                color: AppColors.forestGreen,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'سواء كنت تبحث عن نسيم الصيف العليل بين البساتين، أو دفء الشتاء حول مدفأة الحطب'
                  : 'Whether you seek summer mountain breeze or winter fireside warmth',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedText, fontSize: 16),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
            const SizedBox(height: 48),

            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 768;

                final summerCard = _ExperienceCard(
                  title: isArabic ? 'الجلسات الصيفية بين أشجار التين' : 'Outdoor Summer Fig Orchards',
                  desc: isArabic
                      ? 'استمتع بطعامك في الهواء الجبلي العليل وتحت ظلال أشجار التين المعمرة في النابوع. جلسات عائلية واسعة وإطلالة مباشرة على جبال بلودان.'
                      : 'Dine under mature fig trees in fresh Zabadani mountain air. Spacious family seating with panoramic mountain views.',
                  imageUrl: AppConstants.summerSessionUrl,
                  badgeText: isArabic ? 'الموسم الصيفي' : 'Summer Season',
                  onTap: () => context.go('/booking'),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 700.ms)
                    .slideX(begin: isWide ? -0.1 : 0, end: 0, curve: Curves.easeOutQuad)
                    .slideY(begin: isWide ? 0 : 0.1, end: 0, curve: Curves.easeOutQuad);

                final winterCard = _ExperienceCard(
                  title: isArabic ? 'الصالة الشتوية الزجاجية والمدفأة' : 'Winter Glass Lounge & Fireplace',
                  desc: isArabic
                      ? 'صالة زجاجية مغلقة ومجهزة بأفخم مدفأة حطب دافئة. تتيح لك الاستمتاع بجمال جبال الزبداني المغطاة بالثلج في أجواء شتوية دافئة.'
                      : 'A glass-enclosed warm lounge equipped with a wood fireplace. Enjoy snowy Zabadani mountain views in cozy warmth.',
                  imageUrl: AppConstants.winterLoungeUrl,
                  badgeText: isArabic ? 'الموسم الشتوي' : 'Winter Lounge',
                  onTap: () => context.go('/booking'),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 700.ms)
                    .slideX(begin: isWide ? 0.1 : 0, end: 0, curve: Curves.easeOutQuad)
                    .slideY(begin: isWide ? 0 : 0.1, end: 0, curve: Curves.easeOutQuad);

                return isWide
                    ? Row(
                        children: [
                          Expanded(child: summerCard),
                          const SizedBox(width: 24),
                          Expanded(child: winterCard),
                        ],
                      )
                    : Column(
                        children: [
                          summerCard,
                          const SizedBox(height: 24),
                          winterCard,
                        ],
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedMenuSection(
      BuildContext context, AppStrings strings, bool isArabic, AsyncValue<List<MenuItemModel>> menuAsync) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveContainer(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'أبرز أطباقنا الشامية' : 'Featured Damascene Dishes',
                        style: const TextStyle(
                          color: AppColors.forestGreen,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isArabic
                            ? 'أصالة النكهة الشامية مع أجود اللحوم والمكونات البلدي الطازجة'
                            : 'Authentic Syrian taste with fresh local meats and ingredients',
                        style: const TextStyle(color: AppColors.mutedText, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.go('/menu'),
                  icon: const Icon(Icons.arrow_forward, color: AppColors.figGold),
                  label: Text(
                    isArabic ? 'عرض كل القائمة' : 'View Full Menu',
                    style: const TextStyle(
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),
            const SizedBox(height: 36),

            menuAsync.when(
              data: (items) {
                final featuredItems = items.take(3).toList();
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 768;
                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: List.generate(featuredItems.length, (index) {
                        final item = featuredItems[index];
                        final delayMs = 150 * index;

                        return SizedBox(
                          key: ValueKey(item.id),
                          width: isWide
                              ? (constraints.maxWidth - 40) / 3
                              : constraints.maxWidth,
                          child: Card(
                            elevation: 3,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 180,
                                  width: double.infinity,
                                  child: NetworkImageWithFallback(
                                    imageUrl: item.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isArabic ? item.nameAr : item.nameEn,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppColors.deepCharcoal,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        isArabic ? item.descriptionAr : item.descriptionEn,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.mutedText,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            isArabic
                                                ? '${item.price.toStringAsFixed(0)} ل.س'
                                                : '${item.price.toStringAsFixed(0)} SYP',
                                            style: const TextStyle(
                                              color: AppColors.forestGreen,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: AppColors.figGold.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              item.tags.isNotEmpty
                                                  ? item.tags.first
                                                  : (isArabic ? 'طازج' : 'Fresh'),
                                              style: const TextStyle(
                                                color: AppColors.darkForest,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: delayMs), duration: 600.ms)
                            .slideY(begin: 0.12, end: 0, curve: Curves.easeOutQuad)
                            .scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1));
                      }),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppColors.figGold),
                ),
              ),
              error: (err, stack) => Center(
                child: Text(
                  isArabic ? 'تعذر تحميل القائمة' : 'Failed to load menu',
                  style: const TextStyle(color: AppColors.mutedText),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryPreviewSection(
      BuildContext context, AppStrings strings, bool isArabic, WidgetRef ref) {
    final galleryItems = ref.watch(galleryItemsProvider).take(4).toList();

    return Container(
      color: AppColors.softCream,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveContainer(
        child: Column(
          children: [
            Text(
              isArabic ? 'لقطات من كرم التين' : 'Gallery Highlights',
              style: const TextStyle(
                color: AppColors.forestGreen,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
            const SizedBox(height: 8),
            Text(
              isArabic
                  ? 'لمحة عن جمال الطبيعة، الجلسات العائلية والأطباق المميزة'
                  : 'A glimpse of nature, family ambiance, and signature dishes',
              style: const TextStyle(color: AppColors.mutedText, fontSize: 15),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
            const SizedBox(height: 40),

            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 768;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: List.generate(galleryItems.length, (index) {
                    final item = galleryItems[index];
                    final delayMs = 120 * index;

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          NetworkImageWithFallback(
                            imageUrl: item.imageUrl,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Text(
                              isArabic ? item.titleAr : item.titleEn,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: delayMs), duration: 600.ms)
                        .scale(begin: const Offset(0.92, 0.92), end: const Offset(1, 1), curve: Curves.easeOutQuad);
                  }),
                );
              },
            ),
            const SizedBox(height: 36),

            CustomButton(
              text: isArabic ? 'استعرض كامل المعرض' : 'View Full Gallery',
              icon: Icons.photo_library,
              variant: ButtonVariant.outline,
              onPressed: () => context.go('/gallery'),
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, AppStrings strings, bool isArabic) {
    return Container(
      color: AppColors.forestGreen,
      padding: const EdgeInsets.symmetric(vertical: 72),
      child: ResponsiveContainer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 768;

            final textColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.figGold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isArabic ? 'الموقع والعنوان' : 'Location & Directions',
                    style: const TextStyle(
                      color: AppColors.darkForest,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isArabic ? 'تفضل بزيارتنا في النابوع - الزبداني' : 'Visit Us at Al Nabou - Zabadani',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isArabic
                      ? 'نقع في موقع متميز بإطلالة مرتفعة على جبال الزبداني وبلودان، تحيط بنا بساتين التين والهواء النقي. يتوفر كراج واسع لسيارات الزوار.'
                      : 'Located on an elevated scenic spot overlooking Zabadani and Bloudan mountains surrounded by fig orchards. Free spacious parking available.',
                  style: const TextStyle(
                    color: AppColors.softCream,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(duration: 700.ms)
                .slideX(begin: isWide ? -0.08 : 0, end: 0, curve: Curves.easeOutQuad);

            final mapWidget = LiveGoogleMapWidget(height: 320)
                .animate()
                .fadeIn(delay: 200.ms, duration: 700.ms)
                .slideX(begin: isWide ? 0.08 : 0, end: 0, curve: Curves.easeOutQuad)
                .scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1));

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: textColumn),
                  const SizedBox(width: 40),
                  Expanded(child: mapWidget),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  textColumn,
                  const SizedBox(height: 32),
                  mapWidget,
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final String bgImageUrl;

  const _HighlightCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.bgImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.figGold, width: 1.2),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          NetworkImageWithFallback(
            imageUrl: bgImageUrl,
            fit: BoxFit.cover,
          ),

          // 2. Dark Forest Gradient Overlay for Readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.darkForest.withValues(alpha: 0.75),
                  AppColors.darkForest.withValues(alpha: 0.92),
                ],
              ),
            ),
          ),

          // 3. Content Layer
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.figGold, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: AppColors.figGold, size: 26),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.softCream,
                    fontSize: 13,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final String title;
  final String desc;
  final String imageUrl;
  final String badgeText;
  final VoidCallback onTap;

  const _ExperienceCard({
    required this.title,
    required this.desc,
    required this.imageUrl,
    required this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 240,
                width: double.infinity,
                child: NetworkImageWithFallback(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: AppColors.figGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepCharcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                CustomButton(
                  text: 'احجز لهذه الجلسة',
                  icon: Icons.event_seat,
                  variant: ButtonVariant.outline,
                  onPressed: onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
