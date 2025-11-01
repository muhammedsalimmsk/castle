import 'package:flutter/material.dart';
import 'ShimmerSkelton.dart';
import '../../../Colors/Colors.dart';

class LinkedInLoadingOverlay extends StatelessWidget {
  const LinkedInLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true, // Allows user to interact while loading
        child: Container(
          color: backgroundColor.withOpacity(0.7),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 140), // space for top widget

                // === Top Info Cards ===
                Row(
                  children: List.generate(
                    3,
                    (_) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerSkeleton(height: 12, width: 60),
                            const SizedBox(height: 8),
                            ShimmerSkeleton(
                                height: 20,
                                width: 80,
                                borderRadius: BorderRadius.circular(8)),
                            const SizedBox(height: 6),
                            ShimmerSkeleton(height: 10, width: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // === Priority Chart Card ===
                _cardSkeleton(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerSkeleton(height: 16, width: 180),
                            const SizedBox(height: 14),
                            ShimmerSkeleton(
                                height: 140,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          3,
                          (_) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                ShimmerSkeleton(
                                  height: 12,
                                  width: 12,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                const SizedBox(width: 8),
                                ShimmerSkeleton(height: 12, width: 60),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // === Clients Horizontal Card ===
                _cardSkeleton(
                  height: 170,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        3,
                        (_) => Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerSkeleton(height: 14, width: 100),
                              const SizedBox(height: 8),
                              ShimmerSkeleton(height: 12, width: 60),
                              const SizedBox(height: 10),
                              ShimmerSkeleton(
                                  height: 60,
                                  width: double.infinity,
                                  borderRadius: BorderRadius.circular(12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // === Recent Complaints Card ===
                _cardSkeleton(
                  child: Column(
                    children: List.generate(
                      4,
                      (_) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            ShimmerSkeleton(
                              height: 40,
                              width: 40,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShimmerSkeleton(height: 14, width: 160),
                                  const SizedBox(height: 6),
                                  ShimmerSkeleton(height: 12, width: 100),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ShimmerSkeleton(width: 40, height: 12),
                                const SizedBox(height: 8),
                                ShimmerSkeleton(width: 32, height: 12),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // === Active Workers Card ===
                _cardSkeleton(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 6,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (_, __) => Column(
                      children: [
                        ShimmerSkeleton(
                          height: 60,
                          width: 60,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        const SizedBox(height: 8),
                        ShimmerSkeleton(height: 12, width: 60),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardSkeleton({required Widget child, double? height}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 6,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
