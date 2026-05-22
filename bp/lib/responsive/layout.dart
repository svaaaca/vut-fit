//
// @file layout.dart
// @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
// @brief
// @date 2025-05-14
//

import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;

  const ResponsiveLayout({
    super.key,
    required this.mobileLayout,
    required this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1024.0) {
          return mobileLayout;
        } else {
          return desktopLayout;
        }
      },
    );
  }
}
