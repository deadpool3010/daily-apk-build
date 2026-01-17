import 'package:bandhucare_new/core/export_file/app_exports.dart';

/// Model class for alternative login/register button configuration
class AlternativeButtonConfig {
  final IconData? icon;
  final String label;
  final Color? iconColor;
  final String? imagePath;
  final Size? iconSize;
  final VoidCallback? onTap;

  AlternativeButtonConfig({
    this.icon,
    required this.label,
    this.iconColor,
    this.imagePath,
    this.iconSize,
    this.onTap,
  });
}

/// Widget for displaying a single alternative login/register button
class AlternativeLoginButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color? iconColor;
  final String? imagePath;
  final Size? iconSize;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final double? fontSize;
  final double? width;
  final double? imageSize;
  final double? spacing;

  const AlternativeLoginButton({
    super.key,
    this.icon,
    required this.label,
    this.iconColor,
    this.imagePath,
    this.iconSize,
    this.onTap,
    this.padding,
    this.fontSize,
    this.width,
    this.imageSize,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveImageSize = imageSize ?? 20;
    final double effectiveSpacing = spacing ?? 6;
    final double effectiveFontSize = fontSize ?? 12;

    Widget buttonContent = Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: width != null ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (label == 'lbl_google'.tr)
            Image.asset(
              ImageConstant.googleLogo,
              width: effectiveImageSize,
              height: effectiveImageSize,
            )
          else if (imagePath != null)
            Image.asset(
              imagePath!,
              width: effectiveImageSize,
              height: effectiveImageSize,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image,
                  size: effectiveImageSize,
                  color: Colors.grey,
                );
              },
            )
          else if (icon != null)
            Icon(
              icon,
              color: iconColor,
              size: iconSize?.width ?? effectiveImageSize,
            ),
          SizedBox(width: effectiveSpacing),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.lato(
                fontSize: effectiveFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black87,),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    if (width != null) {
      buttonContent = SizedBox(width: width, child: buttonContent);
    }

    return GestureDetector(onTap: onTap, child: buttonContent);
  }
}

/// Widget for displaying a row of alternative login/register buttons
class AlternativeLoginButtons extends StatelessWidget {
  final List<AlternativeButtonConfig> buttons;
  final double spacing;

  const AlternativeLoginButtons({
    super.key,
    required this.buttons,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    if (buttons.isEmpty) return SizedBox.shrink();

    final List<Widget> children = [];
    for (int i = 0; i < buttons.length; i++) {
      if (i > 0) {
        children.add(SizedBox(width: spacing));
      }
      children.add(
        Expanded(
          child: AlternativeLoginButton(
            icon: buttons[i].icon,
            label: buttons[i].label,
            iconColor: buttons[i].iconColor,
            imagePath: buttons[i].imagePath,
            iconSize: buttons[i].iconSize,
            onTap: buttons[i].onTap,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}
