import 'dart:math';

abstract class TruthOrDareGenerator {
  String getQuestion();
  String getDare();
}

class TruthOrDareLocalGenerator implements TruthOrDareGenerator {
  final Random _random = Random();
  final _questions = [
    "What's your biggest fear?",
    "What's the worst thing you've ever done?",
    "What's the most trouble you've been in?",
    "Have you ever been caught doing something you shouldn't have?",
    "Have you ever had a run in with the law?"
  ];

  final _dares = [
    "Eat a raw piece of garlic",
    "Do 100 squats",
    "Keep three ice cubes in your mouth until they melt",
    "Eat a spoonful of mustard",
    "Dance without music for two minutes",
  ];

  int _lastPickedQuestionNumber;

  @override
  String getQuestion() {
    int randomNumber = _random.nextInt(_questions.length);
    while (randomNumber == _lastPickedQuestionNumber) {
      randomNumber = _random.nextInt(_questions.length);
    }
    _lastPickedQuestionNumber = randomNumber;
    return _questions[randomNumber];
  }

  @override
  String getDare() {
    int randomNumber = _random.nextInt(_dares.length);
    while (randomNumber == _lastPickedQuestionNumber) {
      randomNumber = _random.nextInt(_dares.length);
    }
    _lastPickedQuestionNumber = randomNumber;
    return _dares[randomNumber];
  }
}