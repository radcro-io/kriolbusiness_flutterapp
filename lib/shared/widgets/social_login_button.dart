import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.white30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: borderColor),
      ),
      child: IconButton(
        icon: FaIcon(icon, color: iconColor, size: 30), // Usando FaIcon do font_awesome_flutter
        onPressed: onPressed,
        padding: const EdgeInsets.all(12.0), // Ajuste o padding conforme necessário
      ),
    );
  }
}