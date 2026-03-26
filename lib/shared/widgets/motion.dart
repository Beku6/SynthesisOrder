import 'package:flutter/material.dart';

import '../../app/theme/synor_design_tokens.dart';

AnimatedSwitcherLayoutBuilder synorStackedLayoutBuilder({
  Alignment alignment = Alignment.center,
  StackFit fit = StackFit.passthrough,
}) {
  return (currentChild, previousChildren) {
    return Stack(
      fit: fit,
      alignment: alignment,
      children: [...previousChildren, ?currentChild],
    );
  };
}

AnimatedSwitcherTransitionBuilder synorFadeSlideTransitionBuilder({
  Offset begin = const Offset(0.02, 0),
}) {
  return (child, animation) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: SynorMotion.pageCurve,
      reverseCurve: SynorMotion.pageOutCurve,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(begin: begin, end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  };
}

AnimatedSwitcherTransitionBuilder synorFadeScaleTransitionBuilder({
  double beginScale = 0.985,
}) {
  return (child, animation) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: SynorMotion.pageCurve,
      reverseCurve: SynorMotion.pageOutCurve,
    );
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: beginScale, end: 1).animate(curved),
        child: child,
      ),
    );
  };
}
