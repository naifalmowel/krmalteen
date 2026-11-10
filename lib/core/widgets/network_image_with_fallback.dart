import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NetworkImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NetworkImageWithFallback({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl.isEmpty) {
      imageWidget = _buildPlaceholder();
    } else if (imageUrl.startsWith('assets/')) {
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else {
      imageWidget = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: AppColors.borderLight,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.figGold,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.forestGreen.withValues(alpha: 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.restaurant_menu,
            size: 32,
            color: AppColors.forestGreen,
          ),
          SizedBox(height: 6),
          Text(
            'كرم التين',
            style: TextStyle(
              color: AppColors.forestGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
