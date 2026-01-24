import 'dart:async';
import 'package:bandhucare_new/core/ui/shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class DelayedImageWithShimmer extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget fallbackWidget;

  const DelayedImageWithShimmer({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit,
    required this.fallbackWidget,
  });

  @override
  State<DelayedImageWithShimmer> createState() => _DelayedImageWithShimmerState();
}

class _DelayedImageWithShimmerState extends State<DelayedImageWithShimmer> {
  bool _showImage = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showImage = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_showImage) {
      return Shimmer(
        child: Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
        ),
      );
    }

    return Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Shimmer(
          child: Container(
            width: widget.width,
            height: widget.height,
            color: Colors.white,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return widget.fallbackWidget;
      },
    );
  }
}

