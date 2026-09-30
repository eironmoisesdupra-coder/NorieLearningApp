import 'norie_mascot_state.dart';

class NorieMascotPoseSpec {
  const NorieMascotPoseSpec({
    required this.leftArmTurns,
    required this.rightArmTurns,
    required this.headTurns,
    required this.leftArmLift,
    required this.rightArmLift,
  });

  final double leftArmTurns;
  final double rightArmTurns;
  final double headTurns;
  final double leftArmLift;
  final double rightArmLift;

  static NorieMascotPoseSpec forState(
    NorieMascotState state, {
    required bool reduceMotion,
  }) {
    if (reduceMotion) {
      return const NorieMascotPoseSpec(
        leftArmTurns: 0,
        rightArmTurns: 0,
        headTurns: 0,
        leftArmLift: 0,
        rightArmLift: 0,
      );
    }

    return switch (state) {
      NorieMascotState.pointing => const NorieMascotPoseSpec(
          leftArmTurns: .012,
          rightArmTurns: -.075,
          headTurns: .012,
          leftArmLift: 2,
          rightArmLift: 8,
        ),
      NorieMascotState.guiding => const NorieMascotPoseSpec(
          leftArmTurns: .045,
          rightArmTurns: -.045,
          headTurns: .014,
          leftArmLift: 5,
          rightArmLift: 5,
        ),
      NorieMascotState.speaking => const NorieMascotPoseSpec(
          leftArmTurns: .035,
          rightArmTurns: -.055,
          headTurns: .018,
          leftArmLift: 4,
          rightArmLift: 7,
        ),
      NorieMascotState.challenge => const NorieMascotPoseSpec(
          leftArmTurns: -.055,
          rightArmTurns: .055,
          headTurns: -.014,
          leftArmLift: 7,
          rightArmLift: 7,
        ),
      NorieMascotState.nervous => const NorieMascotPoseSpec(
          leftArmTurns: .026,
          rightArmTurns: -.026,
          headTurns: .025,
          leftArmLift: 3,
          rightArmLift: 3,
        ),
      NorieMascotState.scared => const NorieMascotPoseSpec(
          leftArmTurns: -.07,
          rightArmTurns: .07,
          headTurns: .03,
          leftArmLift: 9,
          rightArmLift: 9,
        ),
      NorieMascotState.idle ||
      NorieMascotState.entering ||
      NorieMascotState.exiting => const NorieMascotPoseSpec(
          leftArmTurns: .010,
          rightArmTurns: -.010,
          headTurns: .006,
          leftArmLift: 1.5,
          rightArmLift: 1.5,
        ),
      _ => const NorieMascotPoseSpec(
          leftArmTurns: 0,
          rightArmTurns: 0,
          headTurns: 0,
          leftArmLift: 0,
          rightArmLift: 0,
        ),
    };
  }

  static bool usesArticulatedBase(NorieMascotState state) {
    return switch (state) {
      NorieMascotState.entering ||
      NorieMascotState.idle ||
      NorieMascotState.guiding ||
      NorieMascotState.pointing ||
      NorieMascotState.speaking ||
      NorieMascotState.nervous ||
      NorieMascotState.scared ||
      NorieMascotState.challenge ||
      NorieMascotState.exiting => true,
      _ => false,
    };
  }
}
