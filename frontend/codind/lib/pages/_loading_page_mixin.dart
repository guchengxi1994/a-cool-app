import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

mixin LoadingPageMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: baseBuild(context),
    );
  }

  baseBuild(BuildContext context) {}
}
