import 'package:flutter/material.dart';

class ResponsiveHelper {
  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  // Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  // Check if screen is desktop/web
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  // Check if screen is large (tablet or desktop)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= mobileBreakpoint;
  }

  // Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 30, vertical: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  }

  // Get max width for content centering on large screens
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1400;
    } else if (isTablet(context)) {
      return 1200;
    }
    return double.infinity;
  }

  // Get grid cross axis count for lists
  static int getGridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) {
      return 3; // 3 columns on desktop
    } else if (isTablet(context)) {
      return 2; // 2 columns on tablet
    }
    return 1; // 1 column on mobile
  }

  // Get responsive card width
  static double? getCardWidth(BuildContext context) {
    if (isDesktop(context)) {
      return null; // Use grid, no fixed width
    } else if (isTablet(context)) {
      return null; // Use grid, no fixed width
    }
    return null; // Full width on mobile
  }
}

