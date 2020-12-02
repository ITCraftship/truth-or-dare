import 'package:flutter/material.dart';

import '../shared/theme/colors.dart';
import '../shared/theme/images.dart';

const Duration _transitionAnimationDuration = Duration(milliseconds: 500);
const Duration _hiThereAnimationDuartion = Duration(seconds: 1);
const double _translationHidden = -100;
const double _buttonPadding = 30;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double _topAlignment = 0.0;
  double _buttonBottomOffset = _translationHidden;
  double _textAlignment = 4;

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
            alignment: Alignment(0, _topAlignment),
            duration: _transitionAnimationDuration,
            curve: Curves.easeInOutBack,
            child: Image.asset(Images.logoBlack),
            onEnd: _animateButton,
          ),
          AnimatedAlign(
            duration: _hiThereAnimationDuartion,
            alignment: Alignment(_textAlignment, 0),
            curve: Curves.elasticOut,
            child: HiThere(),
          ),
          AnimatedPositioned(
            duration: _transitionAnimationDuration,
            bottom: _buttonBottomOffset,
            left: _buttonPadding,
            right: _buttonPadding,
            curve: Curves.easeOutCubic,
            onEnd: _animateText,
            child: BlackButton(
              text: "LET'S PLAY",
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  void _animateLogo() {
    setState(() {
      _topAlignment = -0.7;
    });
  }

  void _animateButton() {
    setState(() {
      _buttonBottomOffset = 32;
    });
  }

  void _animateText() {
    setState(() {
      _textAlignment = 0;
    });
  }
}

class BlackButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const BlackButton({this.onTap, this.text});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      onPressed: onTap,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class HiThere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Hi there!",
          style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          "Are You ready\nfor a little spin?",
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
