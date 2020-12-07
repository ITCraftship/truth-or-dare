import 'dart:math';

abstract class TruthOrDareDataSource {
  String getTruthQuestion();
  String getDareQuestion();
}

class TruthOrDareLocalDataSource implements TruthOrDareDataSource {
  final Random _random = Random();
  final _truthQuestions = [
    "What's your biggest fear?",
    "What's the worst thing you've ever done?",
    "What's the most trouble you've been in?",
    "Have you ever been caught doing something you shouldn't have?",
    "Have you ever had a run in with the law?"
  ];

  final _dareQuestions = [
    "Eat a raw piece of garlic",
    "Do 100 squats",
    "Keep three ice cubes in your mouth until they melt",
    "Eat a spoonful of mustard",
    "Dance without music for two minutes",
  ];

  int _lastPickedQuestionNumber;

  @override
  String getTruthQuestion() {
    int randomNumber = _random.nextInt(_truthQuestions.length);
    while (randomNumber == _lastPickedQuestionNumber) {
      randomNumber = _random.nextInt(_truthQuestions.length);
    }
    _lastPickedQuestionNumber = randomNumber;
    return _truthQuestions[randomNumber];
  }

  @override
  String getDareQuestion() {
    int randomNumber = _random.nextInt(_dareQuestions.length);
    while (randomNumber == _lastPickedQuestionNumber) {
      randomNumber = _random.nextInt(_dareQuestions.length);
    }
    _lastPickedQuestionNumber = randomNumber;
    return _dareQuestions[randomNumber];
  }
}