import 'package:flutter/material.dart';
// import 'package:loading_overlay/loading_overlay.dart';
import 'package:taichi/taichi.dart';

mixin LoadingPageMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TaichiOverlay.simple(
      isLoading: isLoading,
      child: baseLoadingMixinBuild(context),
    );
  }

  baseLoadingMixinBuild(BuildContext context) {}
}
