import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    debugPrint("[debug bloc-observer]:  ${bloc.runtimeType}      $change");
    super.onChange(bloc, change);
  }
}
