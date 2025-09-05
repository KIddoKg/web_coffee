import 'package:flutter/material.dart';
import '../router/router_string.dart';

class NavigationHelper {
  static void navigateToBlogAdmin(BuildContext context) {
    Navigator.pushNamed(context, ScreenName.blogAdmin);
  }

  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      ScreenName.root,
      (route) => false,
    );
  }

  /// Example usage in a widget:
  /// 
  /// ```dart
  /// ElevatedButton(
  ///   onPressed: () => NavigationHelper.navigateToBlogAdmin(context),
  ///   child: const Text('Open Blog Admin'),
  /// )
  /// ```
  static Widget buildBlogAdminButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => navigateToBlogAdmin(context),
      icon: const Icon(Icons.article),
      label: const Text('Blog Admin'),
    );
  }
}