import 'package:bandhucare_new/core/export_file/app_exports.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final Color? iconColor;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool showPasswordToggle;
  final VoidCallback? onTogglePassword;
  final String? countryCode;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final double? height;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final EdgeInsets? contentPadding;
  final double? iconSize;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.iconColor,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.onTogglePassword,
    this.countryCode,
    this.maxLength,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.height = 50,
    this.hintStyle,
    this.textStyle,
    this.contentPadding,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Color(0xFF9BBEF8).withOpacity(0.16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        children: [
          // Country code (for mobile number)
          if (countryCode != null) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                countryCode!,
                style: GoogleFonts.roboto(
                  fontSize: countryCode == '+91' ? 14 : 16,
                  fontWeight: FontWeight.w500,
                  color: iconColor ?? Color(0xFF2563EB),
                ),
              ),
            ),
            Container(width: 1, height: 30, color: Color(0xFFE2E8F0)),
          ],

          // Icon (if provided and not country code)
          if (icon != null && countryCode == null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                icon,
                color: iconColor ?? Color(0xFF2563EB),
                size: iconSize ?? 20,
              ),
            ),

          // Text input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              enabled: enabled,
              maxLength: maxLength,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle:
                    hintStyle ??
                    GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                border: InputBorder.none,
                contentPadding:
                    contentPadding ?? EdgeInsets.symmetric(horizontal: 16),
                counterText: maxLength != null ? '' : null,
              ),
              style:
                  textStyle ??
                  TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
            ),
          ),

          // Show/Hide Password Toggle
          if (showPasswordToggle && onTogglePassword != null)
            GestureDetector(
              onTap: onTogglePassword,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Color(0xFF94A3B8),
                  size: iconSize ?? 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
