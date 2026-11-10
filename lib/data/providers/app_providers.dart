import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/config/app_constants.dart';
import '../models/booking_model.dart';
import '../models/menu_item_model.dart';
import '../models/category_model.dart';
import '../models/gallery_item_model.dart';
import '../repositories/booking_repository.dart';
import '../repositories/menu_repository.dart';
import '../repositories/category_repository.dart';
import '../repositories/gallery_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository();
});

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepository();
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

final galleryRepositoryProvider = Provider<GalleryRepository>((ref) {
  return GalleryRepository();
});

final menuStreamProvider = StreamProvider<List<MenuItemModel>>((ref) {
  final repo = ref.watch(menuRepositoryProvider);
  return repo.getMenuItemsStream();
});

final categoryStreamProvider = StreamProvider<List<CategoryModel>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.getCategoriesStream();
});

final selectedMenuCategoryProvider = StateProvider<String>((ref) => 'all');
final isMenuGridViewProvider = StateProvider<bool>((ref) => true);

class AdminSettingsModel {
  final bool isBookingEnabled;
  final String restaurantPhone;

  AdminSettingsModel({
    this.isBookingEnabled = true,
    this.restaurantPhone = AppConstants.phoneWhatsApp,
  });

  factory AdminSettingsModel.fromMap(Map<String, dynamic> map) {
    return AdminSettingsModel(
      isBookingEnabled: map['isBookingEnabled'] ?? true,
      restaurantPhone: map['restaurantPhone'] ?? AppConstants.phoneWhatsApp,
    );
  }
}

final adminSettingsStreamProvider = StreamProvider<AdminSettingsModel>((ref) {
  return FirebaseFirestore.instance
      .collection('admin_settings')
      .doc('config')
      .snapshots()
      .map((doc) {
        if (!doc.exists || doc.data() == null) {
          return AdminSettingsModel();
        }
        return AdminSettingsModel.fromMap(doc.data()!);
      });
});

final galleryItemsProvider = Provider<List<GalleryItemModel>>((ref) {
  final repo = ref.watch(galleryRepositoryProvider);
  return repo.getGalleryItems();
});

class BookingState {
  final bool isLoading;
  final BookingSubmissionResponse? response;
  final String? error;

  BookingState({
    this.isLoading = false,
    this.response,
    this.error,
  });

  BookingState copyWith({
    bool? isLoading,
    BookingSubmissionResponse? response,
    String? error,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error ?? this.error,
    );
  }
}

class BookingNotifier extends StateNotifier<BookingState> {
  final BookingRepository _repository;

  BookingNotifier(this._repository) : super(BookingState());

  Future<BookingSubmissionResponse> submitBooking(BookingModel booking) async {
    state = state.copyWith(isLoading: true, error: null, response: null);
    try {
      final res = await _repository.submitBooking(booking);
      state = state.copyWith(isLoading: false, response: res);
      return res;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return BookingSubmissionResponse(
        result: BookingSubmitResult.error,
        message: e.toString(),
        booking: booking,
      );
    }
  }

  void reset() {
    state = BookingState();
  }
}

final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return BookingNotifier(repo);
});
