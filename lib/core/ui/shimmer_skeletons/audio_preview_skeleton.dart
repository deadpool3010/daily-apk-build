import 'package:flutter/material.dart';
import 'package:bandhucare_new/core/ui/shimmer/shimmer.dart';

class AudioPreviewSkeleton extends StatelessWidget {
  const AudioPreviewSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      width: 282,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // background
        borderRadius: BorderRadius.circular(7.75),
      ),
      child: Row(
        children: [
          Shimmer(child: _circle(40)),
          const SizedBox(width: 8),
          Shimmer(child: _rect(20, 20)),
          const SizedBox(width: 8),
          Expanded(child: Shimmer(child: _rect(double.infinity, 12))),
          const SizedBox(width: 8),
          Shimmer(child: _rect(18, 18)),
        ],
      ),
    );
  }

  Widget _rect(double w, double h) =>
      Container(width: w, height: h, color: Colors.white);

  Widget _circle(double size) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
    ),
  );
}
