import 'package:flutter/material.dart';

class AppBottomSheet {
  const AppBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double borderRadius = 20,
    double? height,
    bool isDismissible = true,
    bool enableDrag = true,
    Color barrierColor = Colors.black54,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      barrierColor: barrierColor,
      builder: (_) {
        return _BottomSheetContainer(
          borderRadius: borderRadius,
          height: height,
          child: child,
        );
      },
    );
  }
}

class _BottomSheetContainer extends StatelessWidget {
  final double borderRadius;
  final double? height;
  final Widget child;

  const _BottomSheetContainer({
    required this.borderRadius,
    required this.child,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final calculatedHeight = height ?? mediaQuery.size.height * 0.35;

    return Container(
      height: calculatedHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: child,
    );
  }
}
