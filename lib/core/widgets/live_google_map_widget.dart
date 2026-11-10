import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_constants.dart';
import '../theme/app_colors.dart';
import 'custom_button.dart';

class LiveGoogleMapWidget extends StatelessWidget {
  final double height;
  final BorderRadius? borderRadius;

  const LiveGoogleMapWidget({
    super.key,
    this.height = 280,
    this.borderRadius,
  });

  Future<void> _openExternalMap() async {
    final uri = Uri.parse(AppConstants.googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(20);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.forestGreen,
        borderRadius: radius,
        border: Border.all(color: AppColors.figGold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.figGold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.figGold, width: 1.5),
                ),
                child: const Icon(Icons.map, color: AppColors.figGold, size: 30),
              ),
              const SizedBox(height: 10),
              const Text(
                'استراحة ومطعم كرم التين - النابوع، الزبداني',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'انقر أدناه لفتح موقعنا مباشرة على خرائط جوجل والحصول على الاتجاهات',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.softCream,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              CustomButton(
                text: 'افتح اتجاهات الخريطة (Google Maps)',
                icon: Icons.directions,
                variant: ButtonVariant.primaryGold,
                onPressed: _openExternalMap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
