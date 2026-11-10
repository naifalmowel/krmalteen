import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/network_image_with_fallback.dart';
import '../../core/widgets/responsive_container.dart';
import '../../data/models/gallery_item_model.dart';
import '../../data/providers/app_providers.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({super.key});

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
  String _selectedCategory = 'all';

  void _showLightbox(BuildContext context, GalleryItemModel item, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 600, maxWidth: 900),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: NetworkImageWithFallback(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isArabic ? item.titleAr : item.titleEn,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isArabic = strings.isArabic;
    final allGalleryItems = ref.watch(galleryItemsProvider);

    final filteredItems = allGalleryItems.where((item) {
      if (_selectedCategory == 'all') return true;
      return item.category == _selectedCategory;
    }).toList();

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
                    strings.navGallery,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic
                        ? 'معرض الصور: الجلسات الصيفية، الصالة الشتوية، إطلالات جبال الزبداني، وأشهى المأكولات'
                        : 'Gallery: Summer orchards, winter lounge, mountain views, and dishes',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.figGold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Filters & Grid
          ResponsiveContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              children: [
                // Filter Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: isArabic ? 'الكل' : 'All',
                        value: 'all',
                        selectedValue: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                      _FilterChip(
                        label: isArabic ? 'جلسات الصيف' : 'Summer Orchards',
                        value: 'summer',
                        selectedValue: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                      _FilterChip(
                        label: isArabic ? 'الصالة الشتوية' : 'Winter Lounge',
                        value: 'winter_lounge',
                        selectedValue: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                      _FilterChip(
                        label: isArabic ? 'مدفأة الحطب' : 'Fireplace',
                        value: 'fireplace',
                        selectedValue: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                      _FilterChip(
                        label: isArabic ? 'الأطباق والمشاوي' : 'Dishes & Grills',
                        value: 'dishes',
                        selectedValue: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                      _FilterChip(
                        label: isArabic ? 'الإطلالة الجبلية' : 'Mountain Views',
                        value: 'views',
                        selectedValue: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                      _FilterChip(
                        label: isArabic ? 'الحفلات والمناسبات' : 'Events',
                        value: 'events',
                        selectedValue: _selectedCategory,
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Editorial Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 900;
                    final isTablet = constraints.maxWidth > 600;
                    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.25,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return InkWell(
                          onTap: () => _showLightbox(context, item, isArabic),
                          child: ClipRRect(
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
                                        Colors.black.withValues(alpha: 0.75),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          isArabic ? item.titleAr : item.titleEn,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.zoom_in,
                                        color: AppColors.figGold,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.forestGreen,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.deepCharcoal,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.forestGreen : AppColors.borderLight,
          ),
        ),
        onSelected: (selected) {
          if (selected) onSelected(value);
        },
      ),
    );
  }
}
