class GalleryItemModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String category; // 'summer', 'winter_lounge', 'fireplace', 'dishes', 'views', 'events'
  final String imageUrl;

  GalleryItemModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.category,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'titleAr': titleAr,
      'titleEn': titleEn,
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  factory GalleryItemModel.fromMap(Map<String, dynamic> map, String id) {
    return GalleryItemModel(
      id: id,
      titleAr: map['titleAr'] ?? '',
      titleEn: map['titleEn'] ?? '',
      category: map['category'] ?? 'summer',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
