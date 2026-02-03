import 'package:flutter/material.dart';

class DynamicButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final double fontSize;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Color? color;
  final bool isDisable;

  const DynamicButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.width = 360,
    this.height = 50,
    this.fontSize = 18,
    this.leadingIcon,
    this.trailingIcon,
    this.color,
    this.isDisable = false,
  }) : super(key: key);

  // Auto scale based on height
  double _scale(double size) {
    return (height / 50) * size;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDisable == true
              ? const [Colors.grey, Colors.grey]
              : color == null
              ? const [Color(0xFF3865FF), Color(0xFF223D99)]
              : [color!, color!],
        ),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(height / 2),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null) ...[
                  Transform.scale(scale: height / 50, child: leadingIcon),
                  // SizedBox(width: _scale(10)),
                ],
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _scale(fontSize).clamp(11, 22),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (trailingIcon != null) ...[
                  SizedBox(width: _scale(6)),
                  Transform.scale(scale: height / 50, child: trailingIcon),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
