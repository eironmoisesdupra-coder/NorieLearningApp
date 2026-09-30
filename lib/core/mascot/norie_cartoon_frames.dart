import '../assets/norie_assets.dart';
import 'norie_mascot_state.dart';

class NorieCartoonFrame {
  const NorieCartoonFrame({
    required this.asset,
    this.dx = 0,
    this.dy = 0,
    this.scale = 1,
    this.rotationTurns = 0,
  });

  final String asset;
  final double dx;
  final double dy;
  final double scale;
  final double rotationTurns;
}

class NorieCartoonSequence {
  const NorieCartoonSequence({
    required this.frames,
    required this.frameDuration,
    required this.loop,
  });

  final List<NorieCartoonFrame> frames;
  final Duration frameDuration;
  final bool loop;

  static NorieCartoonSequence forState(
    NorieMascotState state, {
    required bool reduceMotion,
  }) {
    if (reduceMotion) {
      return NorieCartoonSequence(
        frames: [NorieCartoonFrame(asset: _assetForState(state))],
        frameDuration: const Duration(milliseconds: 220),
        loop: false,
      );
    }

    return switch (state) {
      NorieMascotState.thinking ||
      NorieMascotState.searching => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 150),
          loop: true,
          frames: [
            NorieCartoonFrame(
              asset: NorieAssets.mascotStudying,
              dy: 1,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotStudying,
              dy: -2,
              rotationTurns: -.006,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotStudying,
              dy: -3,
              scale: 1.012,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotStudying,
              dy: -1,
              rotationTurns: .006,
            ),
          ],
        ),
      NorieMascotState.correct ||
      NorieMascotState.idea ||
      NorieMascotState.celebrating => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 115),
          loop: true,
          frames: [
            NorieCartoonFrame(
              asset: NorieAssets.mascotCelebrating,
              dy: 1,
              scale: .98,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotCelebrating,
              dy: -7,
              scale: 1.04,
              rotationTurns: -.012,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotCelebrating,
              dy: -11,
              scale: 1.07,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotCelebrating,
              dy: -6,
              scale: 1.04,
              rotationTurns: .012,
            ),
          ],
        ),
      NorieMascotState.pointing => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 130),
          loop: true,
          frames: [
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: -1,
              dy: 1,
              rotationTurns: -.010,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 3,
              dy: -2,
              scale: 1.02,
              rotationTurns: -.022,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 5,
              dy: -4,
              scale: 1.035,
              rotationTurns: -.030,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 2,
              dy: -2,
              scale: 1.018,
              rotationTurns: -.018,
            ),
          ],
        ),
      NorieMascotState.guiding ||
      NorieMascotState.speaking => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 145),
          loop: true,
          frames: [
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dy: 1,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: -3,
              dy: -2,
              rotationTurns: .015,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 3,
              dy: -3,
              scale: 1.025,
              rotationTurns: -.015,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dy: -1,
              scale: 1.012,
            ),
          ],
        ),
      NorieMascotState.nervous ||
      NorieMascotState.scared => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 105),
          loop: true,
          frames: [
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: -3,
              dy: 1,
              rotationTurns: -.012,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 3,
              dy: 1,
              rotationTurns: .012,
            ),
          ],
        ),
      NorieMascotState.challenge => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 125),
          loop: true,
          frames: [
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dy: 1,
              scale: .99,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dy: -4,
              scale: 1.035,
              rotationTurns: -.015,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dy: -2,
              scale: 1.02,
              rotationTurns: .015,
            ),
          ],
        ),
      NorieMascotState.entering => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 95),
          loop: false,
          frames: [
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 16,
              dy: 8,
              scale: .88,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 8,
              dy: 4,
              scale: .94,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 3,
              dy: 1,
              scale: .99,
            ),
            NorieCartoonFrame(asset: NorieAssets.mascotBase),
          ],
        ),
      NorieMascotState.exiting => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 95),
          loop: false,
          frames: [
            NorieCartoonFrame(asset: NorieAssets.mascotBase),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 5,
              dy: 2,
              scale: .96,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dx: 12,
              dy: 6,
              scale: .90,
            ),
          ],
        ),
      NorieMascotState.hidden => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 200),
          loop: false,
          frames: [
            NorieCartoonFrame(asset: NorieAssets.mascotBase),
          ],
        ),
      NorieMascotState.idle => const NorieCartoonSequence(
          frameDuration: Duration(milliseconds: 180),
          loop: true,
          frames: [
            NorieCartoonFrame(asset: NorieAssets.mascotBase),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dy: -1,
              scale: 1.006,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dy: -2,
              scale: 1.010,
            ),
            NorieCartoonFrame(
              asset: NorieAssets.mascotBase,
              dy: -1,
              scale: 1.006,
            ),
          ],
        ),
    };
  }

  static String _assetForState(NorieMascotState state) {
    return switch (state) {
      NorieMascotState.thinking ||
      NorieMascotState.searching => NorieAssets.mascotStudying,
      NorieMascotState.correct ||
      NorieMascotState.idea ||
      NorieMascotState.celebrating => NorieAssets.mascotCelebrating,
      _ => NorieAssets.mascotBase,
    };
  }
}
