import 'package:truth_or_dare/shared/theme/images.dart';

enum TruthOrDare {
  truth,
  dare,
}

extension ViewRepresentation on TruthOrDare {
  String get nameImage {
    switch(this) {
      case TruthOrDare.truth:
        return Images.truth;
      case TruthOrDare.dare:
        return Images.dare;
      default:
        throw StateError("Unhandled case");
    }
  }

  String get image {
    switch(this) {
      case TruthOrDare.truth:
        return Images.questionMark;
      case TruthOrDare.dare:
        return Images.exclamationMark;
      default:
        throw StateError("Unhandled case");
    }
  }
}