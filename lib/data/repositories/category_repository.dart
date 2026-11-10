import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';
import '../services/firebase_service.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final List<CategoryModel> _defaultCategories = [
    CategoryModel(id: 'grills', nameAr: 'المشاوي الشامية', nameEn: 'Syrian Grills', sortOrder: 1),
    CategoryModel(id: 'appetizers', nameAr: 'المقبلات الشامية', nameEn: 'Mezze & Appetizers', sortOrder: 2),
    CategoryModel(id: 'mains', nameAr: 'الأطباق الرئيسية', nameEn: 'Main Dishes', sortOrder: 3),
    CategoryModel(id: 'drinks', nameAr: 'المشروبات والعصائر', nameEn: 'Drinks & Juices', sortOrder: 4),
    CategoryModel(id: 'desserts', nameAr: 'الحلويات الشرقية', nameEn: 'Desserts & Sweets', sortOrder: 5),
  ];

  Stream<List<CategoryModel>> getCategoriesStream() async* {
    final isFirebaseReady = await FirebaseService.initialize();
    if (isFirebaseReady) {
      try {
        yield* _firestore.collection('categories').orderBy('sortOrder').snapshots().map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return _defaultCategories;
          }
          return snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
              .toList();
        });
      } catch (_) {
        yield _defaultCategories;
      }
    } else {
      yield _defaultCategories;
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    final isFirebaseReady = await FirebaseService.initialize();
    if (isFirebaseReady) {
      try {
        final snapshot = await _firestore.collection('categories').orderBy('sortOrder').get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
              .toList();
        }
      } catch (_) {}
    }
    return _defaultCategories;
  }
}
