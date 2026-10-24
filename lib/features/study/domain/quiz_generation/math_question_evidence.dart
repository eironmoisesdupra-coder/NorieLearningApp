/// Exact checks for a bounded template grammar. This is computational evidence,
/// not an academic/editorial approval or a general symbolic algebra solver.
sealed class MathQuestionEvidence {
  const MathQuestionEvidence();
  String get identity;
  String get prompt;
  int get answer;
  String get explanation;
  bool get valid;
  String get topic;
  String get grade;
}

class LinearEquationEvidence extends MathQuestionEvidence {
  const LinearEquationEvidence(this.a, this.b, this.c);
  final int a, b, c;
  @override
  bool get valid =>
      a >= 1 &&
      a <= 9 &&
      b >= 0 &&
      b <= 9 &&
      (c - b) % a == 0 &&
      answer >= -10 &&
      answer <= 10;
  @override
  int get answer => a == 0 ? 0 : (c - b) ~/ a;
  @override
  String get identity {
    final divisor = a.gcd(b).gcd(c);
    if (divisor == 0) return 'invalid';
    return 'linear:${a ~/ divisor}:${b ~/ divisor}:${c ~/ divisor}';
  }

  @override
  String get prompt => 'Solve for x: ${a}x + $b = $c.';
  @override
  String get explanation =>
      'Subtract $b from both sides: ${a}x = ${c - b}. Divide both sides by $a: x = $answer. '
      'Check: $a × ($answer) + $b = $c. An answer is correct only if substitution makes both sides equal.';
  @override
  String get topic => 'linear-equations';
  @override
  String get grade => 'g8';
}

class ArithmeticEvidence extends MathQuestionEvidence {
  const ArithmeticEvidence(this.operation, this.left, this.right);
  final String operation;
  final int left, right;
  @override
  bool get valid => operation == 'addition'
      ? left >= 0 &&
          right >= 0 &&
          left <= 20 &&
          right <= 20 &&
          left + right <= 20
      : operation == 'multiplication' &&
          left >= 1 &&
          right >= 1 &&
          left <= 12 &&
          right <= 12;
  @override
  int get answer => operation == 'addition' ? left + right : left * right;
  String get _symbol => operation == 'addition' ? '+' : '×';
  @override
  String get identity =>
      '$operation:${left < right ? left : right}:${left < right ? right : left}';
  @override
  String get prompt => 'Calculate: $left $_symbol $right.';
  @override
  String get explanation => operation == 'addition'
      ? 'Start at $left and count forward $right steps to reach $answer. Check: $answer − $right = $left. Count each added unit once.'
      : '$left groups of $right contain $answer in total. Check: $answer ÷ $right = $left. Multiply the number of groups by the size of each group.';
  @override
  String get topic => operation;
  @override
  String get grade => operation == 'addition' ? 'g1' : 'g3';
}
