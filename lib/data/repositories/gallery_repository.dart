import '../models/gallery_item_model.dart';

class GalleryRepository {
  static final List<GalleryItemModel> _sampleGalleryItems = [
    // g1 - g4
    GalleryItemModel(
      id: 'gal_g1',
      titleAr: 'الجلسات الصيفية بين بساتين التين في النابوع',
      titleEn: 'Summer Outdoor Dining Among Fig Orchards',
      category: 'summer',
      imageUrl: 'assets/images/g1.webp',
    ),
    GalleryItemModel(
      id: 'gal_g2',
      titleAr: 'الصالة الشتوية المغلقة والمدفأة الدافئة',
      titleEn: 'Cozy Winter Glass Lounge with Fireplace',
      category: 'winter_lounge',
      imageUrl: 'assets/images/1.webp',
    ),
    GalleryItemModel(
      id: 'gal_g3',
      titleAr: 'إطلالة جبلية ساحرة على جبال الزبداني',
      titleEn: 'Panoramic Zabadani Mountain Sunset View',
      category: 'views',
      imageUrl: 'assets/images/g4.webp',
    ),

    // 1 - 7
    GalleryItemModel(
      id: 'gal_1',
      titleAr: 'أجواء الطبيعة والهواء النقي في كرم التين',
      titleEn: 'Nature & Fresh Air Vibe',
      category: 'summer',
      imageUrl: 'assets/images/g2.webp',
    ),
    GalleryItemModel(
      id: 'gal_2',
      titleAr: 'جلسات عائلية خاصة في البساتين',
      titleEn: 'Private Family Garden Seating',
      category: 'summer',
      imageUrl: 'assets/images/2.webp',
    ),
    GalleryItemModel(
      id: 'gal_3',
      titleAr: 'سهرة شتوية دافئة',
      titleEn: 'Cozy Winter Evening',
      category: 'fireplace',
      imageUrl: 'assets/images/3.webp',
    ),
    GalleryItemModel(
      id: 'gal_4',
      titleAr: 'ديكورات جميلة خاصة للتصوير',
      titleEn: 'Beautiful decorations, perfect for photography',
      category: 'views',
      imageUrl: 'assets/images/4.webp',
    ),
    GalleryItemModel(
      id: 'gal_5',
      titleAr: 'مناظر خلابة تغمر الزبداني',
      titleEn: 'Breathtaking Scenery',
      category: 'views',
      imageUrl: 'assets/images/5.webp',
    ),
    GalleryItemModel(
      id: 'gal_6',
      titleAr: 'تنظيم الحفلات والمناسبات السعيدة',
      titleEn: 'Event Celebration Setup',
      category: 'events',
      imageUrl: 'assets/images/7.webp',
    ),

    // summer, in, mael, 3ors, out
    GalleryItemModel(
      id: 'gal_summer',
      titleAr: 'جلسات عائلية مميزة في بساتين النابوع',
      titleEn: 'Family Outdoor Seating in Fig Orchards',
      category: 'summer',
      imageUrl: 'assets/images/summer.webp',
    ),
    GalleryItemModel(
      id: 'gal_in',
      titleAr: 'أجواء شتوية دافئة حول مدفأة الحطب',
      titleEn: 'Cozy Fireplace Evening Atmosphere',
      category: 'fireplace',
      imageUrl: 'assets/images/in.webp',
    ),
    GalleryItemModel(
      id: 'gal_mael',
      titleAr: 'أطباق المازة الشامية والمشاوي العائلية',
      titleEn: 'Damascene Mezze & Syrian Grills Platter',
      category: 'dishes',
      imageUrl: 'assets/images/mael.webp',
    ),
    GalleryItemModel(
      id: 'gal_3ors',
      titleAr: 'تنسيق الأعراس والمناسبات الخاصة في كرم التين',
      titleEn: 'Outdoor Wedding & Private Celebration Setup',
      category: 'events',
      imageUrl: 'assets/images/3ors.webp',
    ),
  ];

  List<GalleryItemModel> getGalleryItems() {
    return _sampleGalleryItems;
  }
}
