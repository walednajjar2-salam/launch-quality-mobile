import 'package:flutter/material.dart';
import '../brand_colors.dart';

class PremiumButton extends StatefulWidget {
  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed:
            widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? BrandColors.primaryDark,
        ),
        child: widget.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    BrandColors.textInverse,
                  ),
                ),
              )
            : Text(widget.label),
      ),
    );
  }
}
