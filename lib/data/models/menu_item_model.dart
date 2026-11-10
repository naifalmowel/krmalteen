class MenuItemModel {
  final String id;
  final String category; // 'appetizers', 'grills', 'mains', 'drinks', 'desserts' or dynamic category ID
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final List<String> tags;
  final int sortOrder;

  MenuItemModel({
    required this.id,
    required this.category,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.imageUrl,
    this.isAvailable = true,
    this.tags = const [],
    this.sortOrder = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'categoryId': category,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'price': price,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'tags': tags,
      'sortOrder': sortOrder,
      'order': sortOrder,
    };
  }

  factory MenuItemModel.fromMap(Map<String, dynamic> map, String id) {
    return MenuItemModel(
      id: id,
      category: map['categoryId'] ?? map['category'] ?? 'grills',
      nameAr: map['nameAr'] ?? '',
      nameEn: map['nameEn'] ?? '',
      descriptionAr: map['descriptionAr'] ?? '',
      descriptionEn: map['descriptionEn'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      tags: List<String>.from(map['tags'] ?? []),
      sortOrder: (map['sortOrder'] as num?)?.toInt() ??
          (map['order'] as num?)?.toInt() ??
          0,
    );
  }
}
