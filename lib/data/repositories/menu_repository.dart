import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/config/app_constants.dart';
import '../models/menu_item_model.dart';
import '../services/firebase_service.dart';

class MenuRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// In-memory filter and sort for menu items:
  /// 1. Filters only available items (`isAvailable == true`).
  /// 2. Sorts items ascending by `sortOrder` (`items.sort((a, b) => a.sortOrder - b.sortOrder)`).
  static List<MenuItemModel> _processMenuItems(List<MenuItemModel> items) {
    // Filter available items only
    final availableItems = items.where((item) => item.isAvailable).toList();

    // Sort ascending by sortOrder
    availableItems.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return availableItems;
  }

  /// Sample demo data used whenever Firestore has no items or is not configured.
  static final List<MenuItemModel> _sampleMenuItems = [
    // Syrian Grills
    MenuItemModel(
      id: 'demo_grill_1',
      category: 'grills',
      nameAr: 'مشاوي مشكلة كرم التين (1 كغ)',
      nameEn: 'Krm Alteen Mixed Grill (1 kg)',
      descriptionAr: 'تشكيلة فاخرة من شقف اللحم البلدي، كباب الزبداني، كباب دجاج، وشيش طاووق مع الخضار المشوية والخبز المحمر.',
      descriptionEn: 'Premium selection of fresh local lamb skewers, Zabadani kebab, chicken kebab, and shish tawook with grilled veggies.',
      price: 240000.0,
      imageUrl: AppConstants.foodGrillsUrl,
      isAvailable: true,
      tags: ['عائلي', 'الأكثر طلباً', 'مشوي على الفحم'],
      sortOrder: 1,
    ),
    MenuItemModel(
      id: 'demo_grill_2',
      category: 'grills',
      nameAr: 'كباب الزبداني بالفستق الحلبي',
      nameEn: 'Zabadani Kebab with Pistachio',
      descriptionAr: 'لحم غنم بلدي مفروم طازج متبل بالبهارات الشامية والكرز أو الفستق الحلبي المشوي على الفحم.',
      descriptionEn: 'Minced fresh local lamb seasoned with Syrian spices and roasted pistachios charcoal grilled.',
      price: 180000.0,
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      tags: ['تخصص المطعم', 'شامي أصيل'],
      sortOrder: 2,
    ),
    MenuItemModel(
      id: 'demo_grill_3',
      category: 'grills',
      nameAr: 'شيش طاووق بالثوم والليمون',
      nameEn: 'Marinated Shish Tawook',
      descriptionAr: 'صدور دجاج طرية متبلة بخلطة الليمون وزيت الزيتون والبهارات الخاصة.',
      descriptionEn: 'Tender chicken breast skewers marinated in lemon, olive oil, and house spices.',
      price: 130000.0,
      imageUrl: 'https://images.unsplash.com/photo-1599487488170-d11ec9c172f0?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      tags: ['دجاج طازج'],
      sortOrder: 3,
    ),

    // Appetizers & Mezze
    MenuItemModel(
      id: 'demo_app_1',
      category: 'appetizers',
      nameAr: 'مازة شامية مشكلة فاخرة',
      nameEn: 'Deluxe Damascene Mezze Platter',
      descriptionAr: 'حمص بالحبوب والطحينة، متبل باذنجان مشوي، تبولة دمشقية برمان، بابا غنوج، وورق عنب بالزيت.',
      descriptionEn: 'Creamy hummus, roasted eggplant mutabbal, Damascene tabbouleh, baba ghanoush, and stuffed vine leaves.',
      price: 95000.0,
      imageUrl: AppConstants.foodAppetizersUrl,
      isAvailable: true,
      tags: ['مقبلات باردة', 'نباتي'],
      sortOrder: 4,
    ),
    MenuItemModel(
      id: 'demo_app_2',
      category: 'appetizers',
      nameAr: 'كبة مقلية باللحم والجوز (4 قطع)',
      nameEn: 'Crispy Fried Kibbeh (4 pcs)',
      descriptionAr: 'أقراص الكبة الحلبية المقلية والمحشوة باللحم البلدي المفروم والجوز والصنوبر.',
      descriptionEn: 'Crispy cracked wheat shells stuffed with seasoned minced lamb, walnuts, and pine nuts.',
      price: 75000.0,
      imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      tags: ['مقبلات ساخنة'],
      sortOrder: 5,
    ),
    MenuItemModel(
      id: 'demo_app_3',
      category: 'appetizers',
      nameAr: 'فتوش كرم التين بدبس الرمان',
      nameEn: 'Signature Fig & Pomegranate Fattoush',
      descriptionAr: 'خضار طازجة مع الخبز المحمص ودبس الرمان الجبلي وحبات التين الطازجة الفاخرة.',
      descriptionEn: 'Fresh garden greens, toasted pita crisps, mountain pomegranate molasses, and fresh fig slice accent.',
      price: 55000.0,
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      tags: ['سلطات طازجة', 'خاص بالدار'],
      sortOrder: 6,
    ),

    // Mains
    MenuItemModel(
      id: 'demo_main_1',
      category: 'mains',
      nameAr: 'خروف محشي على الطريقة الشامية',
      nameEn: 'Syrian Stuffed Lamb & Rice',
      descriptionAr: 'لحم خروف محمر طري يقدم مع أوزي ومكسرات محمصة واللبن الخائر.',
      descriptionEn: 'Slow-roasted tender lamb served over seasoned oriental rice with toasted nuts and strained yogurt.',
      price: 210000.0,
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      tags: ['وجبة رئيسية', 'مناسبات'],
      sortOrder: 7,
    ),

    // Drinks
    MenuItemModel(
      id: 'demo_drink_1',
      category: 'drinks',
      nameAr: 'عصير التين الشوكي والكرز الجبلي',
      nameEn: 'Fresh Fig & Mountain Cherry Juice',
      descriptionAr: 'عصير طازج منعش محضّر من ثمار البساتين الجبلية المجاورة.',
      descriptionEn: 'Freshly pressed juice from local mountain orchard fruits.',
      price: 35000.0,
      imageUrl: AppConstants.figOrchardUrl,
      isAvailable: true,
      tags: ['عصائر طازجة', 'مشروبات صيفية'],
      sortOrder: 8,
    ),
    MenuItemModel(
      id: 'demo_drink_2',
      category: 'drinks',
      nameAr: 'شاي على الحطب بالأعشاب الجبلية',
      nameEn: 'Firewood Tea with Mountain Herbs',
      descriptionAr: 'إبريق شاي معتق مخمر على جمر الحطب مع النعناع والزهر البري.',
      descriptionEn: 'Traditional tea brewed over firewood coals infused with fresh mint and wild herbs.',
      price: 25000.0,
      imageUrl: AppConstants.dessertUrl,
      isAvailable: true,
      tags: ['مشروبات ساخنة', 'جمر الحطب'],
      sortOrder: 9,
    ),

    // Desserts
    MenuItemModel(
      id: 'demo_dessert_1',
      category: 'desserts',
      nameAr: 'حلاوة الجبن مع القشطة البلدي ومربى التين',
      nameEn: 'Halawat El Jibn with Fig Preserve',
      descriptionAr: 'شريحة حلاوة الجبن الحمصية الفاخرة المحشوة بالقشطة البلدية والمزينة بمربى التين الجبلي والفستق.',
      descriptionEn: 'Sweet cheese rolls filled with fresh clotted cream, topped with home-style fig preserves and pistachios.',
      price: 45000.0,
      imageUrl: AppConstants.dessertUrl,
      isAvailable: true,
      tags: ['حلويات شرقية', 'القشطة البلدية'],
      sortOrder: 10,
    ),
  ];

  Stream<List<MenuItemModel>> getMenuItemsStream() async* {
    final isFirebaseReady = await FirebaseService.initialize();
    if (isFirebaseReady) {
      try {
        yield* _firestore.collection('menu_items').snapshots().map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return _processMenuItems(List.from(_sampleMenuItems));
          }
          final items = snapshot.docs
              .map((doc) => MenuItemModel.fromMap(doc.data(), doc.id))
              .toList();
          return _processMenuItems(items);
        });
      } catch (_) {
        yield _processMenuItems(List.from(_sampleMenuItems));
      }
    } else {
      yield _processMenuItems(List.from(_sampleMenuItems));
    }
  }

  Future<List<MenuItemModel>> getMenuItems() async {
    final isFirebaseReady = await FirebaseService.initialize();
    if (isFirebaseReady) {
      try {
        final snapshot = await _firestore.collection('menu_items').get();
        if (snapshot.docs.isNotEmpty) {
          final items = snapshot.docs
              .map((doc) => MenuItemModel.fromMap(doc.data(), doc.id))
              .toList();
          return _processMenuItems(items);
        }
      } catch (_) {}
    }
    return _processMenuItems(List.from(_sampleMenuItems));
  }
}
