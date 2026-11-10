import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ButtonVariant { primaryGold, secondaryGreen, outline, outlineLight, darkForest }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primaryGold,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case ButtonVariant.primaryGold:
        bg = AppColors.figGold;
        fg = AppColors.darkForest;
        break;
      case ButtonVariant.secondaryGreen:
        bg = AppColors.forestGreen;
        fg = Colors.white;
        break;
      case ButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.forestGreen;
        border = const BorderSide(color: AppColors.forestGreen, width: 1.5);
        break;
      case ButtonVariant.outlineLight:
        bg = Colors.white.withValues(alpha: 0.12);
        fg = Colors.white;
        border = const BorderSide(color: Colors.white, width: 1.5);
        break;
      case ButtonVariant.darkForest:
        bg = AppColors.darkForest;
        fg = AppColors.warmGold;
        border = const BorderSide(color: AppColors.figGold, width: 1);
        break;
    }

    final childWidget = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: fg,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ],
          );

    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: (variant == ButtonVariant.outline || variant == ButtonVariant.outlineLight) ? 0 : 2,
          side: border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onPressed: isLoading ? null : onPressed,
        child: childWidget,
      ),
    );
  }
}
