import 'package:flutter/material.dart';
import 'package:truth_or_dare/domain/truth_or_dare.dart';
import 'package:truth_or_dare/pages/truth_or_dare_ui_extension.dart';

const Duration _animationDuration = Duration(milliseconds: 500);
const double _heightFactor = 2 / 3;
const double _imageAndTextDivider = 32;

class TruthOrDareTile extends StatelessWidget {
  final TruthOrDare truthOrDare;
  final Color color;
  final double height;
  final Curve curve;
  final double horizontalAlignment;
  final VoidCallback onTap;
  final VoidCallback onAnimationEnd;

  TruthOrDareTile({
    @required this.truthOrDare,
    @required this.color,
    @required this.height,
    @required this.curve,
    @required this.horizontalAlignment,
    @required this.onTap,
    @required this.onAnimationEnd,
  })  : assert(truthOrDare != null),
        assert(color != null),
        assert(height != null),
        assert(curve != null),
        assert(horizontalAlignment != null),
        assert(onTap != null),
        assert(onAnimationEnd != null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        alignment: Alignment(horizontalAlignment, 0),
        curve: curve,
        duration: _animationDuration,
        height: height ?? MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        color: color,
        onEnd: onAnimationEnd,
        child: ImageAndText(truthOrDare, curve, height),
      ),
    );
  }
}

class ImageAndText extends StatelessWidget {
  final TruthOrDare truthOrDare;
  final Curve curve;
  final double height;

  const ImageAndText(
    this.truthOrDare,
    this.curve,
    this.height,
  );

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        heightFactor: _heightFactor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _imageWithNameInserted(),
        ),
      );

  List<Widget> _imageWithNameInserted() {
    final image = Flexible(
      child: Image.asset(
        truthOrDare.image,
        fit: BoxFit.contain,
      ),
    );
    final nameImage = Flexible(
      child: Image.asset(
        truthOrDare.nameImage,
        fit: BoxFit.contain,
      ),
    );
    const divider = SizedBox(height: _imageAndTextDivider);
    if (truthOrDare == TruthOrDare.truth) return [nameImage, divider, image];
    return [image, divider, nameImage];
  }
}
