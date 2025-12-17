import 'package:flutter/material.dart';

class DynamicButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final double fontSize;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const DynamicButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.width = 360,
    this.height = 50,
    this.fontSize = 18,
    this.leadingIcon,
    this.trailingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3865FF), Color(0xFF223D99)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0988F3).withOpacity(0.4),
            // blurRadius: 12,
            // offset: const Offset(0, 4),
          ),
          // BoxShadow(
          //   color: const Color(0xFF0340CC).withOpacity(0.3),
          //   blurRadius: 20,
          //   offset: const Offset(0, 8),
          // ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Leading Icon (optional)
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: 10),
              ],

              // Button Text
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Trailing Icon (optional)
              if (trailingIcon != null) ...[
                const SizedBox(width: 10),
                trailingIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
