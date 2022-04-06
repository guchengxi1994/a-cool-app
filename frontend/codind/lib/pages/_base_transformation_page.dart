import 'package:codind/utils/utils.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

abstract class BaseTransformationPage extends StatefulWidget {
  BaseTransformationPage({Key? key}) : super(key: key);

  @override
  BaseTransformationPageState createState() {
    // ignore: no_logic_in_create_state
    return getState();
  }

  BaseTransformationPageState getState();
}

class BaseTransformationPageState<T extends BaseTransformationPage>
    extends State<T> with TickerProviderStateMixin {
  final GlobalKey _targetKey = GlobalKey();

  final TransformationController transformationController =
      TransformationController();

  Animation<Matrix4>? _animationReset;
  AnimationController? _controllerReset;
  // Matrix4? _homeMatrix;
  List<Widget> actions = [];

  addAction(Widget w) {
    setState(() {
      actions.add(w);
    });
  }

  addActions(List<Widget> ws) {
    setState(() {
      actions.addAll(ws);
    });
  }

  void _onAnimateReset() {
    transformationController.value = _animationReset!.value;
    if (!_controllerReset!.isAnimating) {
      _animationReset?.removeListener(_onAnimateReset);
      _animationReset = null;
      _controllerReset!.reset();
    }
  }

  void _animateResetStop() {
    _controllerReset!.stop();
    _animationReset?.removeListener(_onAnimateReset);
    _animationReset = null;
    _controllerReset!.reset();
  }

  void _onScaleStart(ScaleStartDetails details) {
    // If the user tries to cause a transformation while the reset animation is
    // running, cancel the reset animation.
    if (_controllerReset!.status == AnimationStatus.forward) {
      _animateResetStop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void onCreate() {}
  void onDes() {}
  baseBuild(BuildContext context) {}

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    if (null != _controllerReset) {
      _controllerReset!.dispose();
    }
    transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            leading: PlatformUtils.isWeb
                ? null
                : IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      size: leftBackIconSize,
                    )),
            automaticallyImplyLeading: false,
            actions: actions,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: InteractiveViewer(
                constrained: false,
                clipBehavior: Clip.none,
                key: _targetKey,
                scaleEnabled: true,
                transformationController: transformationController,
                boundaryMargin: const EdgeInsets.all(1000),
                minScale: 0.05,
                maxScale: 2,
                // onInteractionStart: _onScaleStart,
                child: baseBuild(context),
              ),
            ),
          ],
        ));
  }
}
