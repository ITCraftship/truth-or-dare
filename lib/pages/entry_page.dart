import 'dart:async';

import 'package:flutter/material.dart';
import 'package:truth_or_dare/shared/theme/colors.dart';
import 'package:truth_or_dare/shared/theme/images.dart';

const double _itcLogoBottomOffset = 70;
const double _translationHidden = -300;
const double _translationVisible = 0;
const Duration _transitionAnimationDuration = Duration(milliseconds: 500);

class EntryPage extends StatefulWidget {
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> with SingleTickerProviderStateMixin {
  Timer _timer;
  Color _color = AppColors.blueBackground;
  double _questionMarkRightOffset = _translationHidden;
  double _exclamationMarkLeftOffset = _translationHidden;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 1500), (timer) => _changeColor());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _showQuestionMark());
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: _transitionAnimationDuration,
            color: _color,
          ),
          AnimatedPositioned(
            top: 0,
            bottom: 0,
            right: _questionMarkRightOffset,
            duration: _transitionAnimationDuration,
            curve: _exclamationMarkLeftOffset == _translationHidden ? Curves.bounceIn : Curves.bounceOut,
            child: Image.asset(
              Images.questionMark,
              fit: BoxFit.fitHeight,
            ),
          ),
          AnimatedPositioned(
            top: 0,
            bottom: 0,
            left: _exclamationMarkLeftOffset,
            duration: _transitionAnimationDuration,
            curve: Curves.bounceIn,
            child: Image.asset(
              Images.exclamationMark,
              fit: BoxFit.fitHeight,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(Images.logoBlack),
          ),
          Positioned(
            bottom: _itcLogoBottomOffset,
            left: 0,
            right: 0,
            child: Image.asset(Images.itcLogo),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FlatButton(
              onPressed: () => _reset(),
              child: Text("RESET BUTTON"),
            ),
          )
        ],
      ),
    );
  }

  void _showQuestionMark() {
    setState(() {
      _questionMarkRightOffset = _translationVisible;
    });
  }

  void _changeColor() {
    setState(() {
      _color = AppColors.redBackground;
      _questionMarkRightOffset = _translationHidden;
      _exclamationMarkLeftOffset = _translationVisible;
    });
  }

  void _reset() {
    setState(() {
      _color = AppColors.blueBackground;
      _questionMarkRightOffset = _translationVisible;
      _exclamationMarkLeftOffset = _translationHidden;
    });
    _timer?.cancel();
    _timer = Timer.periodic(_transitionAnimationDuration, (timer) => _changeColor());
  }
}
