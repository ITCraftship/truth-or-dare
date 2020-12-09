import 'package:flutter/material.dart';
import 'package:truth_or_dare/domain/truth_or_dare.dart';
import 'package:truth_or_dare/domain/truth_or_dare_data_source.dart';
import 'package:truth_or_dare/pages/truth_or_dare_page.dart';
import 'package:truth_or_dare/utils/no_animation_navigator_push.dart';
import 'package:truth_or_dare/widgets/truth_or_dare_tile.dart';

import '../shared/theme/colors.dart';

class SelectionPage extends StatefulWidget {
  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  Curve _curve = Curves.easeInBack;
  double _heightTruth;
  double _heightDare;
  Color _colorTruth = AppColors.redBackground;
  double _alignmentTruth = 2;
  double _alignmentDare = -2;
  bool _animationInProgress = false;
  bool _didPushPage = false;
  TruthOrDare _pageToPush;

  double get _fullScreenHeight => MediaQuery.of(context).size.height;

  double get _halfScreenHeight => MediaQuery.of(context).size.height / 2;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _curve = Curves.easeOutBack;
        _colorTruth = AppColors.blueBackground;
        _alignmentTruth = 0;
        _alignmentDare = 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.redBackground,
          ),
          TruthOrDareTile(
            truthOrDare: TruthOrDare.truth,
            color: _colorTruth,
            height: _heightTruth ?? _halfScreenHeight,
            curve: _curve,
            horizontalAlignment: _alignmentTruth,
            onTap: _onShowTap,
            onAnimationEnd: () => _onAnimationEnd(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TruthOrDareTile(
              truthOrDare: TruthOrDare.dare,
              color: AppColors.redBackground,
              height: _heightDare ?? _halfScreenHeight,
              curve: _curve,
              horizontalAlignment: _alignmentDare,
              onTap: _onDareTap,
              onAnimationEnd: () => _onAnimationEnd(),
            ),
          ),
        ],
      ),
    );
  }

  void _onShowTap() {
    if (_animationInProgress) return;
    _animationInProgress = true;
    _pageToPush = TruthOrDare.truth;
    if (_isInInitialState()) {
      _animateTruth();
    } else {
      _revertAnimations();
    }
  }

  void _onDareTap() {
    if (_animationInProgress) return;
    _animationInProgress = true;
    _pageToPush = TruthOrDare.dare;
    if (_isInInitialState()) {
      _animateDare();
    } else {
      _revertAnimations();
    }
  }

  bool _isInInitialState() => _heightDare != 0 && _heightTruth != 0;

  void _animateTruth() {
    setState(() {
      _curve = Curves.easeInBack;
      _heightTruth = _fullScreenHeight;
      _heightDare = 0;
    });
  }

  void _animateDare() {
    setState(() {
      _curve = Curves.easeInBack;
      _heightTruth = 0;
      _heightDare = _fullScreenHeight;
    });
  }

  void _revertAnimations() {
    _animationInProgress = true;
    setState(() {
      _curve = Curves.easeOutBack;
      _heightTruth = _halfScreenHeight;
      _heightDare = _halfScreenHeight;
    });
  }

  void _onAnimationEnd() {
    _animationInProgress = false;
    if (!_isInInitialState()) {
      _navigateToTruthOrDarePage(_pageToPush);
    }
  }

  void _navigateToTruthOrDarePage(TruthOrDare truthOrDare) {
    if (_didPushPage) return;
    _didPushPage = true;
    pushWithoutAnimation(context, TruthOrDarePage(truthOrDare, TruthOrDareLocalGenerator())).then((_) {
      _didPushPage = false;
      _revertAnimations();
    });
  }
}
