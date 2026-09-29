enum NorieMascotState {
  hidden,
  entering,
  idle,
  guiding,
  pointing,
  speaking,
  thinking,
  idea,
  correct,
  celebrating,
  nervous,
  scared,
  challenge,
  searching,
  exiting,
}

enum NorieMascotPriority {
  idle,
  ambient,
  feedback,
  challenge,
  celebration,
  guide,
  hidden,
}

enum NorieCelebrationLevel {
  encouraging,
  standard,
  perfect,
}

class NorieMascotEvent {
  const NorieMascotEvent({
    required this.state,
    required this.priority,
    this.duration,
    this.targetId,
    this.speech,
    this.celebrationLevel,
  });

  final NorieMascotState state;
  final NorieMascotPriority priority;
  final Duration? duration;
  final String? targetId;
  final String? speech;
  final NorieCelebrationLevel? celebrationLevel;

  bool get isTransient => duration != null;
}
