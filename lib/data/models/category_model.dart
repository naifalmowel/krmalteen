class CategoryModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final int sortOrder;

  CategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'nameAr': nameAr,
      'nameEn': nameEn,
      'sortOrder': sortOrder,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      nameAr: map['nameAr'] ?? '',
      nameEn: map['nameEn'] ?? '',
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}
