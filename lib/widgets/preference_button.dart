import 'package:flutter/material.dart';

class PreferenceButton extends StatelessWidget {
  const PreferenceButton({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.08 : 1,
      duration: const Duration(milliseconds: 180),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: selected ? selectedColor : null,
          side: BorderSide(
            color: selected ? selectedColor : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
