import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const LikeButton({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon, size: 32),
    );
  }
}
