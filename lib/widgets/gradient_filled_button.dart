import 'package:flutter/material.dart';

class GradientFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  const GradientFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: isEnabled
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(255, 98, 205, 203),
                  Color.fromARGB(255, 69, 153, 219),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : const LinearGradient(
                colors: [
                  Color.fromARGB(126, 98, 205, 203),
                  Color.fromARGB(117, 69, 154, 219),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        boxShadow: [
          if (isEnabled)
            BoxShadow(
              color: const Color.fromARGB(35, 255, 255, 255).withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
        ],
      ),
      child: FilledButton(
        onPressed: isEnabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
