import 'package:flutter/material.dart';

class ChooseLanguageDropDown extends StatelessWidget {
  final String title;
  final String value;
  final bool isExpanded;
  final VoidCallback onTap;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;

  const ChooseLanguageDropDown({
    super.key,
    required this.title,
    required this.value,
    required this.isExpanded,
    required this.onTap,
    this.height = 60,
    this.width,
    this.margin = const EdgeInsets.symmetric(horizontal: 27),
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    this.backgroundColor = const Color(0xFFF5F7FB),
    this.borderColor = const Color(0xFFD7E1FF),
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Container(
          width: width ?? double.infinity,
          constraints: BoxConstraints(minHeight: height),
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 217, 217, 217),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black54,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
