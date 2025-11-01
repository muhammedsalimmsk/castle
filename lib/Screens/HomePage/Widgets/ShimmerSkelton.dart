import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  const ShimmerSkeleton(
      {this.width = double.infinity,
      this.height = 12,
      BorderRadius? borderRadius,
      super.key})
      : borderRadius =
            borderRadius ?? const BorderRadius.all(Radius.circular(6));

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Colors.grey.shade300, borderRadius: borderRadius),
      ),
    );
  }
}
