import 'dart:async';

import 'package:flutter/material.dart';
import 'package:truth_or_dare/pages/welcome_page.dart';
import 'package:truth_or_dare/shared/theme/colors.dart';
import 'package:truth_or_dare/shared/theme/images.dart';
import 'package:truth_or_dare/utils/no_animation_navigator_push.dart';

const double _itcLogoBottomOffset = 70;
const double _translationHidden = -300;
const double _translationVisible = -100;
const double _translationQuestionMarkHidden = -600;
const double _translationQuestionMarkVisible = -310;
const Duration _transitionAnimationDuration = Duration(milliseconds: 700);
const Duration _changeColorTimerDuration = Duration(milliseconds: 1500);

class EntryPage extends StatefulWidget {
  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> with SingleTickerProviderStateMixin {
  Timer _timer;
  Color _color = AppColors.blueBackground;
  double _questionMarkRightOffset = _translationQuestionMarkHidden;
  double _exclamationMarkLeftOffset = _translationHidden;
  double _itcLogoOffset = _itcLogoBottomOffset;

  @override
  void initState() {
    _timer = Timer(_transitionAnimationDuration, () {
      _showQuestionMark();
      _startChangeColorTimer();
    });
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
            onEnd: _runHideAllAnimation,
          ),
          AnimatedPositioned(
            top: 0,
            bottom: 0,
            right: _questionMarkRightOffset,
            duration: _transitionAnimationDuration,
            curve: _questionMarkRightOffset == _translationQuestionMarkHidden ? Curves.elasticIn : Curves.elasticOut,
            onEnd: _animateExclamationMark,
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
            curve: _exclamationMarkLeftOffset == _translationHidden ? Curves.elasticIn : Curves.elasticOut,
            child: Image.asset(
              Images.exclamationMark,
              fit: BoxFit.fitHeight,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(Images.logoBlack),
          ),
          AnimatedPositioned(
            duration: _transitionAnimationDuration,
            bottom: _itcLogoOffset,
            left: 0,
            right: 0,
            curve: Curves.bounceOut,
            child: Image.asset(Images.itcLogo),
            onEnd: _navigateToWelcomePage,
          ),
        ],
      ),
    );
  }

  void _startChangeColorTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_changeColorTimerDuration, (timer) => _changeColor());
  }

  void _showQuestionMark() {
    setState(() {
      _questionMarkRightOffset = _translationQuestionMarkVisible;
    });
  }

  void _changeColor() {
    setState(() {
      _color = AppColors.redBackground;
      _questionMarkRightOffset = _translationQuestionMarkHidden;
    });
  }

  void _animateExclamationMark() {
    if (_questionMarkRightOffset == _translationQuestionMarkHidden) {
      setState(() {
        _exclamationMarkLeftOffset = _translationVisible;
      });
    }
  }

  void _runHideAllAnimation() {
    _hideExclamationMark(onEnd: () => _hideItcLogo());
  }

  void _hideExclamationMark({VoidCallback onEnd}) {
    _timer?.cancel();
    _timer = Timer.periodic(_transitionAnimationDuration, (timer) {
      setState(() {
        _exclamationMarkLeftOffset = _translationHidden;
      });
      onEnd();
    });
  }

  void _hideItcLogo() {
    _timer?.cancel();
    _timer = Timer.periodic(_transitionAnimationDuration, (timer) {
      setState(() {
        _itcLogoOffset = _translationHidden;
      });
    });
  }

  void _navigateToWelcomePage() {
    pushReplacementWithoutAnimation(context, WelcomePage());
  }
}
