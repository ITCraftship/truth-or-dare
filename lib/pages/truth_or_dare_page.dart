import 'dart:async';

import 'package:flutter/material.dart';
import 'package:truth_or_dare/domain/truth_or_dare.dart';
import 'package:truth_or_dare/pages/truth_or_dare_ui_extension.dart';
import 'package:truth_or_dare/domain/truth_or_dare_data_source.dart';
import 'package:truth_or_dare/shared/theme/dims.dart';
import 'package:truth_or_dare/shared/theme/images.dart';
import 'package:truth_or_dare/shared/theme/typography.dart';
import 'package:truth_or_dare/widgets/truth_or_dare_tile.dart';

import '../shared/theme/colors.dart';

const Duration _hideAnimationTimerDuration = Duration(milliseconds: 500);
const Duration _animationDuration = Duration(seconds: 1);
const double _alignmentCenter = 0;
const double _horizontalTextAlignmentHidden = -6;
const double _popButtonHorizontalAlignmentHidden = -2;
const double _popButtonHorizontalAlignmentVisible = -0.8;
const double _nextButtonHorizontalAlignmentHidden = 3;
const double _nextButtonHorizontalAlignmentVisible = 0.8;
const double _imageHorizontalAlignmentHidden = 5;
const double _questionTextHorizontalAlignmentHidden = -6;
const double _popButtonVerticalAlignment = -0.95;
const double _nextButtonVerticalAlignment = 0.95;
const double _questionTextWidthFactor = 2 / 3;

class TruthOrDarePage extends StatefulWidget {
  final TruthOrDare truthOrDare;
  final TruthOrDareGenerator truthOrDareDataSource;

  const TruthOrDarePage(this.truthOrDare, this.truthOrDareDataSource);

  @override
  _TruthOrDarePageState createState() => _TruthOrDarePageState();
}

class _TruthOrDarePageState extends State<TruthOrDarePage> {
  Timer _timer;
  double _horizontalImageAlignment = _alignmentCenter;
  double _horizontalTextAlignment = _questionTextHorizontalAlignmentHidden;
  double _popButtonHorizontalAlignment = _popButtonHorizontalAlignmentHidden;
  double _nextButtonHorizontalAlignment = _nextButtonHorizontalAlignmentHidden;
  Curve _curve;
  Curve _textCurve = Curves.elasticOut;
  bool _popping = false;
  bool _changeQuestion = false;
  String _text = "";

  @override
  void initState() {
    super.initState();
    _initializeHideTimer();
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
          Container(
            color: _getColor(),
          ),
          AnimatedAlign(
            duration: _animationDuration,
            alignment: Alignment(_horizontalImageAlignment, _alignmentCenter),
            curve: _curve ?? Curves.elasticIn,
            onEnd: _onImageAnimationEnd,
            child: ImageAndText(
              widget.truthOrDare,
              Curves.linear,
              MediaQuery.of(context).size.height,
            ),
          ),
          AnimatedAlign(
            duration: _animationDuration,
            alignment: Alignment(_horizontalTextAlignment, _alignmentCenter),
            curve: _textCurve ?? Curves.elasticIn,
            onEnd: _onTextAnimationEnd,
            child: FractionallySizedBox(
              widthFactor: _questionTextWidthFactor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.truthOrDare.nameImage,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: Dim.d40),
                  Text(
                    _text,
                    style: AppTypography.semiBold30,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: AnimatedAlign(
              duration: _animationDuration,
              curve: _textCurve ?? Curves.elasticIn,
              alignment: Alignment(_popButtonHorizontalAlignment, _popButtonVerticalAlignment),
              child: GestureDetector(
                onTap: _prepareForPop,
                child: Image.asset(Images.backArrow),
              ),
            ),
          ),
          SafeArea(
            child: AnimatedAlign(
              duration: _animationDuration,
              curve: _textCurve ?? Curves.elasticIn,
              alignment: Alignment(_nextButtonHorizontalAlignment, _nextButtonVerticalAlignment),
              child: GestureDetector(
                onTap: _showNext,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("NEXT", style: AppTypography.extraBold24),
                    const SizedBox(width: Dim.d16),
                    Image.asset(Images.nextArrow),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initializeHideTimer() {
    _timer = Timer(_hideAnimationTimerDuration, () {
      setState(() {
        _horizontalImageAlignment = _imageHorizontalAlignmentHidden;
      });
    });
  }

  void _onImageAnimationEnd() {
    if (!_popping) {
      _text = _getQuestion();
      _showText();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _showText() {
    setState(() {
      _horizontalTextAlignment = _alignmentCenter;
    });
  }

  void _onTextAnimationEnd() {
    if (_popping) return;
    _showButtons();
    if (_changeQuestion) {
      _text = _getQuestion();
      _showText();
      _changeQuestion = false;
    }
  }

  void _showButtons() {
    setState(() {
      _popButtonHorizontalAlignment = _popButtonHorizontalAlignmentVisible;
      _nextButtonHorizontalAlignment = _nextButtonHorizontalAlignmentVisible;
    });
  }

  void _prepareForPop() {
    _popping = true;
    setState(() {
      _textCurve = Curves.elasticOut;
      _curve = Curves.elasticOut;
      _horizontalImageAlignment = _alignmentCenter;
      _horizontalTextAlignment = _questionTextHorizontalAlignmentHidden;
      _popButtonHorizontalAlignment = _popButtonHorizontalAlignmentHidden;
      _nextButtonHorizontalAlignment = _nextButtonHorizontalAlignmentHidden;
    });
  }

  void _showNext() {
    _changeQuestion = true;
    setState(() {
      _horizontalTextAlignment = _horizontalTextAlignmentHidden;
    });
  }

  Color _getColor() => widget.truthOrDare == TruthOrDare.truth ? AppColors.blueBackground : AppColors.redBackground;

  String _getQuestion() => widget.truthOrDare == TruthOrDare.truth
      ? widget.truthOrDareDataSource.getQuestion()
      : widget.truthOrDareDataSource.getDare();
}
