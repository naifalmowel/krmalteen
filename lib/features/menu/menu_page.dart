import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/network_image_with_fallback.dart';
import '../../core/widgets/responsive_container.dart';
import '../../data/models/menu_item_model.dart';
import '../../data/providers/app_providers.dart';

class MenuPage extends ConsumerStatefulWidget {
  const MenuPage({super.key});

  @override
  ConsumerState<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends ConsumerState<MenuPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final isArabic = strings.isArabic;
    final selectedCategory = ref.watch(selectedMenuCategoryProvider);
    final isGridView = ref.watch(isMenuGridViewProvider);
    final menuAsync = ref.watch(menuStreamProvider);
    final categoriesAsync = ref.watch(categoryStreamProvider);

    return Column(
      children: [
          // Header Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
            decoration: const BoxDecoration(
              color: AppColors.darkForest,
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=1600&q=80',
                ),
                fit: BoxFit.cover,
                opacity: 0.25,
              ),
            ),
            child: ResponsiveContainer(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Text(
                    strings.navMenu,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isArabic
                        ? 'أشهى المشاوي السورية، المازة الشامية الفاخرة، والعصائر المنعشة'
                        : 'Authentic Syrian grills, Damascene mezze, and refreshing beverages',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.figGold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Menu Section
          ResponsiveContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              children: [
                // Search, Filter & Grid/List Toggle Bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.trim().toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: isArabic ? 'بحث في قائمة الطعام...' : 'Search menu items...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.forestGreen),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Grid / List View Toggle Button
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: AppColors.forestGreen,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.figGold, width: 1.2),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            ref.read(isMenuGridViewProvider.notifier).state = !isGridView;
                          },
                          child: Center(
                            child: Icon(
                              isGridView ? Icons.view_list : Icons.grid_view,
                              color: AppColors.figGold,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Category Filter Chips (Dynamic from Firestore 'categories' collection)
                categoriesAsync.when(
                  data: (categories) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _CategoryChip(
                            label: strings.catAll,
                            categoryKey: 'all',
                            isSelected: selectedCategory == 'all',
                          ),
                          ...categories.map((cat) {
                            return _CategoryChip(
                              label: isArabic ? cat.nameAr : cat.nameEn,
                              categoryKey: cat.id,
                              isSelected: selectedCategory == cat.id,
                            );
                          }),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 40,
                    child: Center(child: CircularProgressIndicator(color: AppColors.figGold)),
                  ),
                  error: (err, stack) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _CategoryChip(
                          label: strings.catAll,
                          categoryKey: 'all',
                          isSelected: selectedCategory == 'all',
                        ),
                        _CategoryChip(
                          label: strings.catGrills,
                          categoryKey: 'grills',
                          isSelected: selectedCategory == 'grills',
                        ),
                        _CategoryChip(
                          label: strings.catAppetizers,
                          categoryKey: 'appetizers',
                          isSelected: selectedCategory == 'appetizers',
                        ),
                        _CategoryChip(
                          label: strings.catMains,
                          categoryKey: 'mains',
                          isSelected: selectedCategory == 'mains',
                        ),
                        _CategoryChip(
                          label: strings.catDrinks,
                          categoryKey: 'drinks',
                          isSelected: selectedCategory == 'drinks',
                        ),
                        _CategoryChip(
                          label: strings.catDesserts,
                          categoryKey: 'desserts',
                          isSelected: selectedCategory == 'desserts',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Notice Banner regarding editable sample prices
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.figGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.figGold.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.forestGreen, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isArabic
                              ? 'ملاحظة: الأسعار الموضحة هي أسعار استرشادية قابلة للتعديل حسب الموسم وتوافر اللحوم البلدي الطازجة.'
                              : 'Note: Displayed prices are indicative and adjustable based on seasonal market availability.',
                          style: const TextStyle(
                            color: AppColors.deepCharcoal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Menu Items (Grid View vs List View)
                menuAsync.when(
                  data: (items) {
                    final filteredItems = items.where((item) {
                      final matchesCategory =
                          selectedCategory == 'all' || item.category == selectedCategory;
                      final matchesSearch = _searchQuery.isEmpty ||
                          item.nameAr.toLowerCase().contains(_searchQuery) ||
                          item.nameEn.toLowerCase().contains(_searchQuery) ||
                          item.descriptionAr.toLowerCase().contains(_searchQuery);
                      return matchesCategory && matchesSearch;
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            const Icon(Icons.search_off, size: 48, color: AppColors.mutedText),
                            const SizedBox(height: 12),
                            Text(
                              isArabic
                                  ? 'لم نجد أطباق تطابق بحثك'
                                  : 'No items match your search criteria',
                              style: const TextStyle(color: AppColors.mutedText, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }

                    final screenWidth = MediaQuery.sizeOf(context).width;
                    final isWide = screenWidth > 800;
                    final crossAxisCount = isWide ? 3 : (screenWidth > 550 ? 2 : 1);
                    final childAspectRatio = isWide ? 1.1 : (screenWidth > 550 ? 0.88 : 1.5);

                    return isGridView
                        ? GridView.builder(
                            key: const ValueKey('grid_view_mode'),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: childAspectRatio,
                            ),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return _MenuItemCard(
                                key: ValueKey(item.id),
                                item: item,
                                isArabic: isArabic,
                              );
                            },
                          )
                        : ListView.separated(
                            key: const ValueKey('list_view_mode'),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredItems.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return _MenuItemHorizontalCard(
                                key: ValueKey(item.id),
                                item: item,
                                isArabic: isArabic,
                              );
                            },
                          );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(48),
                      child: CircularProgressIndicator(color: AppColors.figGold),
                    ),
                  ),
                  error: (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        isArabic ? 'تعذر تحميل قائمة الطعام' : 'Failed to load menu items',
                        style: const TextStyle(color: AppColors.mutedText),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CategoryChip extends ConsumerWidget {
  final String label;
  final String categoryKey;
  final bool isSelected;

  const _CategoryChip({
    required this.label,
    required this.categoryKey,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.forestGreen,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.deepCharcoal,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: isSelected ? AppColors.forestGreen : AppColors.borderLight,
          ),
        ),
        onSelected: (selected) {
          if (selected) {
            ref.read(selectedMenuCategoryProvider.notifier).state = categoryKey;
          }
        },
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItemModel item;
  final bool isArabic;

  const _MenuItemCard({
    super.key,
    required this.item,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Availability Tag
          Expanded(
            flex: 7,
            child: Stack(
              fit: StackFit.expand,
              children: [
                NetworkImageWithFallback(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                ),
                if (!item.isAvailable)
                  Container(
                    color: Colors.black.withValues(alpha: 0.6),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isArabic ? 'غير متوفر حالياً' : 'Currently Unavailable',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? item.nameAr : item.nameEn,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.deepCharcoal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isArabic ? item.descriptionAr : item.descriptionEn,
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          AppFormatters.formatCurrency(item.price, isArabic: isArabic),
                          style: const TextStyle(
                            color: AppColors.forestGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (item.tags.isNotEmpty)
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.figGold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.tags.first,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.darkForest,
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItemHorizontalCard extends StatelessWidget {
  final MenuItemModel item;
  final bool isArabic;

  const _MenuItemHorizontalCard({
    super.key,
    required this.item,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 130,
        child: Row(
          children: [
            SizedBox(
              width: 140,
              height: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageWithFallback(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  if (!item.isAvailable)
                    Container(
                      color: Colors.black.withValues(alpha: 0.6),
                      child: Center(
                        child: Text(
                          isArabic ? 'غير متوفر' : 'Unavailable',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? item.nameAr : item.nameEn,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.deepCharcoal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic ? item.descriptionAr : item.descriptionEn,
                          style: const TextStyle(
                            color: AppColors.mutedText,
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppFormatters.formatCurrency(item.price, isArabic: isArabic),
                          style: const TextStyle(
                            color: AppColors.forestGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                          ),
                        ),
                        if (item.tags.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.figGold.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.tags.first,
                              style: const TextStyle(
                                color: AppColors.darkForest,
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
