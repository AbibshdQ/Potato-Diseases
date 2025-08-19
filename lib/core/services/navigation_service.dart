import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// NavigationService untuk mengelola navigasi aplikasi
/// Simpan file ini di: lib/core/services/navigation_service.dart
class NavigationService {
  // Singleton pattern
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  // Global key untuk navigator
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Get current context
  static BuildContext? get currentContext => navigatorKey.currentContext;

  // Get current state
  static NavigatorState? get currentState => navigatorKey.currentState;

  /// Navigate to Onboarding Screen
  static Future<void> navigateToOnboarding() async {
    await currentState?.pushNamedAndRemoveUntil(
      '/onboarding', // Sesuaikan dengan route name Anda
      (route) => false,
    );
  }

  /// Navigate to Upload Screen (Home)
  static Future<void> navigateToUpload() async {
    await currentState?.pushNamedAndRemoveUntil(
      '/upload', // Sesuaikan dengan route name Anda
      (route) => false,
    );
  }

  /// Navigate to Home Screen
  static Future<void> navigateToHome() async {
    await currentState?.pushNamedAndRemoveUntil(
      '/home', // Sesuaikan dengan route name Anda
      (route) => false,
    );
  }

  /// Navigate to any screen with route name
  static Future<void> navigateTo(String routeName, {Object? arguments}) async {
    await currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace current screen with new screen
  static Future<void> navigateAndReplace(String routeName, {Object? arguments}) async {
    await currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate and remove all previous routes
  static Future<void> navigateAndRemoveUntil(String routeName, {Object? arguments}) async {
    await currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop current screen
  static void goBack([dynamic result]) {
    if (canGoBack()) {
      currentState?.pop(result);
    }
  }

  /// Check if can go back
  static bool canGoBack() {
    return currentState?.canPop() ?? false;
  }

  /// Pop until specific route
  static void popUntil(String routeName) {
    currentState?.popUntil(ModalRoute.withName(routeName));
  }

  /// Exit app (Android only)
  static void exitApp() {
    SystemNavigator.pop();
  }

  /// Show dialog
  static Future<T?> showDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    RouteSettings? routeSettings,
  }) async {
    if (currentContext == null) return null;

    return await Navigator.of(currentContext!, rootNavigator: true).push<T>(
      DialogRoute<T>(
        context: currentContext!,
        builder: (context) => dialog,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor ?? Colors.black54,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        settings: routeSettings,
      ),
    );
  }

  /// Show bottom sheet
  static Future<T?> showBottomSheet<T>({
    required Widget bottomSheet,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? routeSettings,
  }) async {
    if (currentContext == null) return null;

    return await showModalBottomSheet<T>(
      context: currentContext!,
      builder: (context) => bottomSheet,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      routeSettings: routeSettings,
    );
  }

  /// Show snackbar
  static void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
    Color? textColor,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? width,
    ShapeBorder? shape,
  }) {
    if (currentContext == null) return;

    ScaffoldMessenger.of(currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
        behavior: behavior,
        margin: margin,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        width: width,
        shape: shape,
      ),
    );
  }

  /// Clear all snackbars
  static void clearSnackBars() {
    if (currentContext == null) return;
    ScaffoldMessenger.of(currentContext!).clearSnackBars();
  }
}