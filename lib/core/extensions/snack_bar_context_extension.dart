import 'package:e_commeric/core/themes/app_color.dart';
import 'package:flutter/material.dart';

extension SnackBarContextExtension on BuildContext {
  Object? get routeArguments => ModalRoute.of(this)?.settings.arguments;
  static bool _isLoading = false;

  void showLoadingDialog([bool isDismissible = true]) {
    if (_isLoading) return;
    showAdaptiveDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: isDismissible,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) {
              _isLoading = false;
            }
          },
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
    _isLoading = true;
  }

  void showErrorSnackBar(String message) {
    _showSnackBar(message, AppColor.danger);
  }

  void showSuccessSnackBar(String message) {
    _showSnackBar(message, AppColor.success);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    final messenger = ScaffoldMessenger.of(this);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
  }
}
