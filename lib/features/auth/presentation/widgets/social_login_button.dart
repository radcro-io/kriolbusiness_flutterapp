// lib/features/auth/presentation/widgets/social_login_button.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kriolbusiness/config/theme/app_colors.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.iconColor,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.papayaWhip,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
      ),
      child: IconButton(
        icon: FaIcon(icon, color: iconColor, size: 30),
        onPressed: isLoading ? null : onPressed,
        padding: const EdgeInsets.all(12.0),
      ),
    );
  }
}