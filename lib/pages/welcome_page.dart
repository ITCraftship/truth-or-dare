import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:truth_or_dare/pages/selection_page.dart';
import 'package:truth_or_dare/shared/theme/dims.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import 'package:truth_or_dare/utils/no_animation_navigator_push.dart';
import 'package:truth_or_dare/widgets/black_button.dart';

import '../shared/theme/colors.dart';
import '../shared/theme/images.dart';

const Duration _transitionAnimationDuration = Duration(milliseconds: 500);
const Duration _hiThereAnimationDuration = Duration(seconds: 1);
const double _translationHidden = -100;
const double _buttonPadding = 30;
const double _logoAfterAnimationTopAlignment = -0.7;
const double _logoHorizontalAlignmentHidden = -5;
const double _buttonBottomOffsetVisible = 32;
const double _centerAlignment = 0;
const double _hiThereAlignmentHidden = 4;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double _topAlignment = _centerAlignment;
  double _buttonBottomOffset = _translationHidden;
  double _hiThereAlignment = _hiThereAlignmentHidden;
  double _logoHorizontalAlignment = _centerAlignment;
  double _buttonLeft = _buttonPadding;
  double _buttonRight = _buttonPadding;
  bool _isHideAnimationRunning = false;
  Curve _curve;
  Duration _transitionDuration = _transitionAnimationDuration;
  bool _isInitialAnimationRunning = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateLogo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.redBackground),
          AnimatedAlign(
            alignment: Alignment(_logoHorizontalAlignment, _topAlignment),
            duration: _transitionDuration,
            curve: _curve ?? Curves.easeInOutBack,
            child: Image.asset(Images.logoBlack),
            onEnd: _animateButton,
          ),
          AnimatedAlign(
            duration: _hiThereAnimationDuration,
            alignment: Alignment(_hiThereAlignment, _centerAlignment),
            curve: _curve ?? Curves.elasticOut,
            child: _HiThere(),
            onEnd: _onHiThereAnimationEnd,
          ),
          AnimatedPositioned(
            duration: _transitionDuration,
            bottom: _buttonBottomOffset,
            left: _buttonLeft,
            right: _buttonRight,
            curve: _curve ?? Curves.easeOutCubic,
            onEnd: _animateText,
            child: BlackButton(
              text: "LET'S PLAY",
              onTap: _animateHide,
            ),
          ),
        ],
      ),
    );
  }

  void _animateLogo() {
    if (_isHideAnimationRunning) return;
    setState(() {
      _topAlignment = _logoAfterAnimationTopAlignment;
    });
  }

  void _animateButton() {
    if (_isHideAnimationRunning) return;
    setState(() {
      _buttonBottomOffset = _buttonBottomOffsetVisible;
    });
  }

  void _animateText() {
    if (_isHideAnimationRunning) return;
    setState(() {
      _hiThereAlignment = _centerAlignment;
    });
  }

  void _animateHide() {
    if (_isInitialAnimationRunning) return;
    _isHideAnimationRunning = true;
    setState(() {
      _curve = Curves.elasticIn;
      _logoHorizontalAlignment = _logoHorizontalAlignmentHidden;
      _buttonLeft = -MediaQuery.of(context).size.width;
      _buttonRight = MediaQuery.of(context).size.width;
      _hiThereAlignment = _hiThereAlignmentHidden;
      _transitionDuration = _hiThereAnimationDuration;
    });
  }

  void _onHiThereAnimationEnd() {
    _isInitialAnimationRunning = false;
    if (!_isHideAnimationRunning) return;
    _navigateToSelectionPage();
  }

  void _navigateToSelectionPage() {
    pushWithoutAnimation(context, SelectionPage());
  }
}

class _HiThere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Hi there!",
          style: AppTypography.extraBold48,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Dim.d10),
        Text(
          "Are You ready\nfor a little spin?",
          style: AppTypography.semiBold30,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
