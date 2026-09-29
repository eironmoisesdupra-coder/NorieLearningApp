import 'norie_mascot_state.dart';

class NorieMascotMotionSpec {
  const NorieMascotMotionSpec({
    required this.duration,
    required this.translationX,
    required this.translationY,
    required this.scaleDelta,
    required this.rotationTurns,
    required this.loops,
  });

  final Duration duration;
  final double translationX;
  final double translationY;
  final double scaleDelta;
  final double rotationTurns;
  final bool loops;

  static NorieMascotMotionSpec forState(
    NorieMascotState state, {
    required bool reduceMotion,
  }) {
    if (reduceMotion) {
      return NorieMascotMotionSpec(
        duration: const Duration(milliseconds: 180),
        translationX: 0,
        translationY: state == NorieMascotState.hidden ? 0 : 2,
        scaleDelta: state == NorieMascotState.celebrating ? .015 : .008,
        rotationTurns: 0,
        loops: false,
      );
    }

    return switch (state) {
      NorieMascotState.hidden => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 180),
          translationX: 0,
          translationY: 0,
          scaleDelta: 0,
          rotationTurns: 0,
          loops: false,
        ),
      NorieMascotState.entering => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 550),
          translationX: 12,
          translationY: 4,
          scaleDelta: .04,
          rotationTurns: -.012,
          loops: false,
        ),
      NorieMascotState.exiting => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 450),
          translationX: 12,
          translationY: 4,
          scaleDelta: -.03,
          rotationTurns: .012,
          loops: false,
        ),
      NorieMascotState.idle => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 1800),
          translationX: 0,
          translationY: 4,
          scaleDelta: .025,
          rotationTurns: .004,
          loops: true,
        ),
      NorieMascotState.thinking ||
      NorieMascotState.searching => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 1350),
          translationX: 3,
          translationY: 3,
          scaleDelta: .015,
          rotationTurns: .012,
          loops: true,
        ),
      NorieMascotState.guiding ||
      NorieMascotState.pointing ||
      NorieMascotState.speaking => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 1250),
          translationX: 3,
          translationY: 3,
          scaleDelta: .018,
          rotationTurns: .008,
          loops: true,
        ),
      NorieMascotState.correct => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 700),
          translationX: 0,
          translationY: 10,
          scaleDelta: .11,
          rotationTurns: -.014,
          loops: false,
        ),
      NorieMascotState.idea => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 900),
          translationX: 0,
          translationY: 8,
          scaleDelta: .08,
          rotationTurns: .012,
          loops: false,
        ),
      NorieMascotState.celebrating => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 1600),
          translationX: 6,
          translationY: 14,
          scaleDelta: .13,
          rotationTurns: .018,
          loops: true,
        ),
      NorieMascotState.nervous => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 900),
          translationX: 4,
          translationY: 2,
          scaleDelta: -.02,
          rotationTurns: .01,
          loops: true,
        ),
      NorieMascotState.scared => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 900),
          translationX: 7,
          translationY: 4,
          scaleDelta: -.045,
          rotationTurns: .016,
          loops: true,
        ),
      NorieMascotState.challenge => const NorieMascotMotionSpec(
          duration: Duration(milliseconds: 1000),
          translationX: 3,
          translationY: 4,
          scaleDelta: .045,
          rotationTurns: -.02,
          loops: true,
        ),
    };
  }
}
